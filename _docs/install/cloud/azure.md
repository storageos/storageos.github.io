---
layout: guide
title: StorageOS Docs - Azure
anchor: install
module: install/cloud/azure
---

# Azure

## Azure Container Service (AKS) Installation

Since AKS runs `kubelet` in a container, an additional parameter was
added to the StorageOS driver in Kubernetes 1.10 to allow configuring the
location where StorageOS presents volume devices to `kubelet` to see the
devices.

We expect StorageOS to run on AKS when it supports Kubernetes
1.10.  Until then, you may deploy your own Kubernetes cluster on Azure using the acs-engine instructions below.

## acs-engine

`acs-engine` is an open-source tool from Microsoft that can be used to deploy your own Kubernetes cluster on Azure.  It allows
you to specify the version of Kubernetes and specific features.

For more information and installation instructions, consult the
[acs-engine Kubernetes guide](https://github.com/Azure/acs-engine/blob/master/docs/kubernetes/deploy.md)

There are various [examples of Kubernetes cluster definitions](https://github.com/Azure/acs-engine/tree/master/examples) for acs-engine, but the important thing is to specify kubernetes 1.10 as StorageOS requires this version to support running with kubelet in a container.

Example definition (saved as `kubernetes.json` for use in the instructions below):

```json
{
  "apiVersion": "vlabs",
  "properties": {
    "orchestratorProfile": {
      "orchestratorType": "Kubernetes",
      "orchestratorRelease": "1.10",
      "kubernetesConfig": {
          "addons": [
              {
                  "name": "tiller",
                  "enabled" : true
              }
          ]
      }
    },
    "masterProfile": {
      "count": 1,
      "dnsPrefix": "mycluster",
      "vmSize": "Standard_D2_v2"
    },
    "agentPoolProfiles": [
      {
        "name": "minions",
        "count": 3,
        "vmSize": "Standard_D2_v2",
        "availabilityProfile": "AvailabilitySet",
        "customNodeLabels": {
          "env": "test"
        }
      }
    ],
    "linuxProfile": {
      "adminUsername": "azureuser",
      "ssh": {
        "publicKeys": [
          {
            "keyData": ""
          }
        ]
      }
    },
    "servicePrincipalProfile": {
      "clientId": "",
      "secret": ""
    }
  }
}
```

Unless you specify a publickey, acs-engine is going to create an ssh key pair for you under `_output` directory. It grants you access to the kubernetes master from which you can hop to all minions.

To deploy a cluster through acs-engine you need your Azure Subscription ID.
You can retrieve your subscription ID through the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest). If you don't have the Azure CLI installed then you can sign in to [Azure Cloud Shell](https://shell.azure.com) to run the commands there:

```bash
# save the current subscription id in a variable for later...
subscriptionId=$(az account show --output tsv --query id)

# or show the current account (to copy locally if running from the Cloud Shell)
az account show --output json

# or list your subscriptions (if you have multiple subscriptions)
az account list
```

With your subscription id you can now run `acs-engine` to deploy your kubernetes cluster:

```bash
# IMPORTANT: enter your own parameters, especially 'subscription-id'
acs-engine deploy --subscription-id $subscriptionId \
    --dns-prefix storageos --location westus2 \
    --auto-suffix --api-model kubernetes.json
```

The deployment also creates a KUBECONFIG for your cluster under the `_output` directory. The exact filename depends on the dns prefix and location you specified. To set the KUBECONFIG for the example above:

```bash
KUBECONFIG=~/mydir/_output/storageos/kubeconfig/kubeconfig.westus2.json
```

Running `kubectl cluster-info` should now connect to your new cluster.

Consult the [acs-engine documentation](https://github.com/Azure/acs-engine/blob/master/docs/kubernetes/deploy.md)
for more information.

### StorageOS installation

First, make sure the [StorageOS CLI]({%link _docs/reference/cli/index.md %}) has
been installed on your local machine.

Once the Kubernetes cluster is available, you can proceed to install the [Helm client](https://docs.helm.sh/using_helm/#installing-helm) in your machine.

The Kubernetes cluster has got tiller add on enabled, hence the helm server is running.

Once Helm is installed and configured for the cluster, checkout the StorageOS
Helm Chart and install:

```bash
git clone https://github.com/storageos/helm-chart.git storageos
cd storageos
helm install . --name storageos-test \
  --set image.repository=storageos/node \
  --set image.tag=0.10.0 \
  --set service.type=LoadBalancer \
  --set cluster.join="$(storageos cluster create)" \
  --set cluster.sharedDir=/var/lib/kubelet/plugins/kubernetes.io~storageos
```

After the `helm install` command completes, finish the installation by running
the commands suggested.  These will vary depending if custom install options
were specified, otherwise the defaults will work:

```bash
ClusterIP=$(kubectl get svc/storageos --namespace default -o custom-columns=IP:spec.clusterIP --no-headers=true)
ApiAddress=$(echo -n "tcp://$ClusterIP:5705" | base64)
kubectl patch secret/storageos-api --namespace default --patch "{\"data\": {\"apiAddress\": \"$ApiAddress\"}}"
```

If you receive the error `storageos: command not found`, make sure the StorageOS
CLI was installed into your path.

Since `kubelet` runs in a container in ACS, it's important to set `cluster.sharedDir`
to `/var/lib/kubelet/plugins/kubernetes.io~storageos`, which is available to the
`kubelet`.  The StorageOS container will use this directory to publish its
devices in.

See the [StorageOS Helm Chart](https://github.com/storageos/helm-chart) for more
information and available options.

# Next steps

Verify the cluster is healthy with the StorageOS CLI:

```bash
$ export STORAGEOS_HOST=$(kubectl get svc/storageos --namespace default -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
$ storageos node ls
NAME                        ADDRESS             HEALTH                  SCHEDULER           VOLUMES             TOTAL               USED                VERSION                 LABELS
k8s-agentpool1-40905336-0   10.240.0.4          Healthy About an hour   false               M: 1, R: 0          29.02GiB            11.38%              ad3f0cc (ad3f0cc rev)   
k8s-agentpool1-40905336-1   10.240.0.66         Healthy About an hour   false               M: 0, R: 0          29.02GiB            12.06%              ad3f0cc (ad3f0cc rev)   
k8s-agentpool1-40905336-2   10.240.0.35         Healthy About an hour   true                M: 0, R: 0          29.02GiB            11.14%              ad3f0cc (ad3f0cc rev)   
```

You can now create a Persistent Volume Claim:

```bash
cat <<EOF | kubectl create -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: redis
  labels:
    cluster: demo-storageos-node
    region: europe-west2-a
  annotations:
    volume.beta.kubernetes.io/storage-class: fast
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
EOF
```

And a Pod that uses it:

```bash
cat <<EOF | kubectl create -f -
apiVersion: v1
kind: Pod
metadata:
  name: redis
spec:
  containers:
    - name: redis
      image: kubernetes/redis:v1
      env:
        - name: MASTER
          value: "true"
      ports:
        - containerPort: 6379
      volumeMounts:
        - mountPath: /redis-master-data
          name: redis-data
  volumes:
    - name: redis-data
      persistentVolumeClaim:
        claimName: redis
EOF
```

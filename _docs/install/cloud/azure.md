---
layout: guide
title: StorageOS Docs - Azure
anchor: install
module: install/cloud/azure
---

# Azure

## Azure Container Service (AKS) Installation

We expect StorageOS to run on AKS when it reaches GA and it supports Kubernetes
1.10.  Since AKS runs `kubelet` in a container, an additional parameter was
added to the StorageOS driver in Kubernetes 1.10 to allow configuring the
location where StorageOS presents volume devices to `kubelet` to see the
devices.

Until then, you may deploy your own Kubernetes cluster on Azure using the ACS
Kubernetes installation below.

## Azure Container Service (ACS) Kubernetes Installation

`acs-engine` is the open-source tool that Microsoft uses to deploy AKS clusters, and it can be used to deploy your own Kubernetes cluster on Azure.  It allows
you to specify the version of Kubernetes and specific features.

For more information and installation instructions, consult the
[acs-engine kubernetes guide](https://github.com/Azure/acs-engine/blob/master/docs/kubernetes/deploy.md)


The template below can be used in place of `examples/kubernetes.json` in the "Deploy" step:

```json
{
  "apiVersion": "vlabs",
  "properties": {
    "orchestratorProfile": {
      "orchestratorType": "Kubernetes",
      "orchestratorRelease": "1.10",
      "kubernetesConfig": {
        "kubeletConfig" : {
          "--feature-gates": "MountPropagation=true"
        },
        "apiServerConfig" : {
          "--feature-gates": "MountPropagation=true"
        }
      }
    },
    "masterProfile": {
      "count": 1,
      "dnsPrefix": "",
      "vmSize": "Standard_D2_v2"
    },
    "agentPoolProfiles": [
      {
        "name": "agentpool1",
        "count": 3,
        "vmSize": "Standard_D2_v2",
        "availabilityProfile": "AvailabilitySet"
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

The `MountPropagation` feature must be enabled, as this allows the StorageOS
container to expose devices.

To create the cluster, save the json file as `kubernetes.json` and run:

```bash
# IMPORTANT: enter your own parameters, especially 'subscription-id'
acs-engine deploy --subscription-id 51ac25de-afdg-9201-d923-8d8e8e8e8e8e \
    --dns-prefix storageos --location westus2 \
    --auto-suffix --api-model kubernetes.json
```

Consult the [acs-engine documentation](https://github.com/Azure/acs-engine/blob/master/docs/kubernetes/deploy.md)
for more information.

### StorageOS installation

First, make sure the [StorageOS CLI]({%link _docs/reference/cli/index.md %}) has
been installed on your local machine.

Once the Kubernetes cluster is available, use [Helm](https://helm.sh/) to
install StorageOS.

Once Helm is installed and configured for the cluster, checkout the StorageOS
Helm Chart and install:

```bash
git clone https://github.com/storageos/helm-chart.git storageos
cd storageos
helm install . --name storageos-test \
  --set image.repository=soegarots/node,image.tag=ad3f0ccb6,service.type=LoadBalancer,cluster.join="$(storageos cluster create)",cluster.sharedDir=/var/lib/kubelet/plugins/kubernetes.io~storageos
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
$ STORAGEOS_HOST=$(kubectl get svc/storageos --namespace default -o custom-columns=IP:status.loadBalancer.ingress[0].ip --no-headers=true)
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
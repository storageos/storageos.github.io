# Cluster Operator examples

Before deploying a StorageOS cluster, create a Secret to define the StorageOS
API Username and Password in base64 encoding.

```bash
kubectl create -f - <<END
apiVersion: v1
kind: Secret
metadata:
  name: "storageos-api"
  namespace: "default"
  labels:
    app: "storageos"
type: "kubernetes.io/storageos"
data:
  # echo -n '<secret>' | base64
  apiUsername: c3RvcmFnZW9z
  apiPassword: c3RvcmFnZW9z
END
```


Create a `cluster-config.yaml` according to your needs from the examples below.

```bash
kubectl create -f cluster-config.yaml
```

Note that StorageOS will be deployed in `spec.namespace` (storageos by
default), irrespective of what NameSpace the CR is defined in.


&nbsp; <!-- this is a blank line -->

# Examples

> You can checkout all the parameters configurable in the
> [configuration]({%link _docs/reference/cluster-operator/configuration.md %})
> page.

All examples must reference the `storageos-api` Secret.

```bash
spec:
  secretRefName: "storageos-api" # Reference to the Secret created in the previous step
  secretRefNamespace: "default"  # Namespace of the Secret
```

Check out [Cluster Definition
examples](https://github.com/storageos/deploy/tree/master/k8s/deploy-storageos/cluster-operator) for full CR files.

## Installing with an external etcd

```bash
spec:
  kvBackend:
    address: '10.43.93.95:2379' # IP of the SVC that exposes ETCD
  # address: '10.42.15.23:2379,10.42.12.22:2379,10.42.13.16:2379' # You can specify individual IPs of the etcd servers
    backend: 'etcd'
```

## Installing to a subset of nodes

In this case we select nodes that are workers. To make sure that StorageOS doesn't start in Master nodes. 

You can see the labels in the nodes by `kubectl get node --show-labels`.

```bash
spec:
  nodeSelectorTerms:
    - matchExpressions:
      - key: "node-role.kubernetes.io/worker"
        operator: In
        values:
        - "true"

# OpenShift uses "node-role.kubernetes.io/compute=true"
# Rancher uses "node-role.kubernetes.io/worker=true"
# Kops uses "node-role.kubernetes.io/node="
```

> Different provisioners and Kubernetes distributions use node labels
> differently to specify master vs workers. Node Taints are not enough to
> make sure StorageOS doesn't start in a node. The
> [JOIN](https://docs.storageos.com/docs/prerequisites/clusterdiscovery)
> variable is defined by the operator by selecting all the nodes that match the
> `nodeSelectorTerms`.

## Enabling CSI

```bash
spec:
  csi:
    enable: true
  # enableProvisionCreds: false
  # enableControllerPublishCreds: false
  # enableNodePublishCreds: false
```

The credentials must be defined in the `storageos-api` Secret

```bash
apiVersion: v1
kind: Secret
metadata:
  name: "storageos-api"
  namespace: "default"
  labels:
    app: "storageos"
type: "kubernetes.io/storageos"
data:
  # echo -n '<secret>' | base64
  apiUsername: c3RvcmFnZW9z
  apiPassword: c3RvcmFnZW9z
  # Add base64 encoded creds below for CSI credentials.
  # csiProvisionUsername:
  # csiProvisionPassword:
  # csiControllerPublishUsername:
  # csiControllerPublishPassword:
  # csiNodePublishUsername:
  # csiNodePublishPassword:
```

## Specifying a shared directory for use with kubelet as a container

```bash
spec:
  sharedDir: '/var/lib/kubelet/plugins/kubernetes.io~storageos'
```

## Defining pod resource requests and reservations

```bash
spec:
  resources:
    requests:
      memory: "256Mi"
  #   cpu: "1"
  # limits:
  #   memory: "4Gi"
```

Limiting StorageOS can cause malfunction for IO to StorageOS volumes, therefore
we do not currently recommend applying upper limits to resources for StorageOS
pods.


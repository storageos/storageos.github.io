# Cluster Operator examples

> You can find the source code in the [cluster-operator
> repository](https://github.com/storageos/cluster-operator).

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

&nbsp; <!-- this is a blank line -->

# Examples

> You can checkout all the parameters configurable in the [StorageOSCluster
> Resource
> Configuration](https://github.com/storageos/cluster-operator#storageoscluster-resource-configuration) page.

All examples must reference the `storageos-api` Secret.

```bash
spec:
  secretRefName: "storageos-api" # Reference to the Secret created in the previous step
  secretRefNamespace: "default"  # Namespace of the Secret
```

Check out [Cluster Definition
examples](https://github.com/storageos/deploy/tree/master/k8s/deploy-storageos/cluster-operator) for full CR files.

### External etcd 

```bash
spec:
  kvBackend:
    address: '10.43.93.95:2379' # IP of the SVC that exposes ETCD
  # address: '10.42.15.23:2379,10.42.12.22:2379,10.42.13.16:2379' # You can specify individual IPs of the etcd servers
    backend: 'etcd'
```

### Select nodes where StorageOS will deploy

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
# Rancher uses "node-role.kubernetes.io/worker="
# Kops uses "node-role.kubernetes.io/node="
```

> Different provisioners and Kubernetes distributions use node labels
> differently to specify master vs workers. Node Taints are not enough to
> make sure StorageOS doesn't start in a node. The
> [JOIN](https://docs.storageos.com/docs/prerequisites/clusterdiscovery)
> variable is defined by the operator by selecting all the nodes that match the
> `nodeSelectorTerms`.

### Enabled CSI

```bash
spec:
  csi:
    enable: true
  # enableProvisionCreds: false
  # enableControllerPublishCreds: false
  # enableNodePublishCreds: false
```

The Creds must be defined in the `storageos-api` Secret

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

### Shared Dir for Kubelet as a container

```bash
spec:
  sharedDir: '/var/lib/kubelet/plugins/kubernetes.io~storageos'
```

### Define Pod resources

```bash
spec:
  resources:
    requests:
      memory: "256Mi"
  #   cpu: "1"
  # limits:
  #   memory: "4Gi"
```

Limiting StorageOS can cause malfunction for Read/Write to StorageOS volumes,
hence it is not recommended to tightly restrict Pod resources.


## Install StorageOS operator

The StorageOS cluster operator is the recommended installation procedure to
deploy a StorageOS cluster.

The StorageOS cluster operator is a [Kubernetes native
application](https://kubernetes.io/docs/concepts/extend-kubernetes/extend-cluster/)
developed to deploy and configure StorageOS clusters, and assist with
maintenance operations.

The StorageOS operator can be installed with Helm.

### Install

```bash
helm repo add storageos https://charts.storageos.com
helm install storageos/storageoscluster-operator --namespace storageos-operator
```

> The Helm chart can be found in the [Charts public
> repository](https://github.com/storageos/charts).

> The StorageOS Cluster Operator source code can be found in the
> [cluster-operator repository](https://github.com/storageos/cluster-operator).

The operator is a Kubernetes controller that watches the `StorageOSCluster`
CRD. Once the controller is ready, a StorageOS cluster definition can be
created. The operator will deploy a StorageOS cluster based on the
configuration specified in the cluster definition.

### Create a Secret

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

### Trigger a StorageOS installation

> This is a Cluster Definition example. Checkout the `spec` parameters
> available on the [Resource Configuration
> page](https://github.com/storageos/cluster-operator#storageoscluster-resource-configuration).

```bash
kubectl create -f - <<END
apiVersion: "storageos.com/v1alpha1"
kind: "StorageOSCluster"
metadata:
  name: "example-storageos"
spec:
  secretRefName: "storageos-api" # Reference from the Secret created in the previous step
  secretRefNamespace: "default"  # Namespace of the Secret
  images:
    nodeContainer: "storageos/node:1.0.0-rc5" # StorageOS version
  resources:
    requests:
    memory: "128Mi"
END
```

You can find more examples such as deployments with CSI or deployments referencing a external etcd kv store.
store for StorageOS in this [repo](TODO).

# Cluster Operator

The StorageOS cluster operator is the recommended installation procedure to
deploy a StorageOS cluster.

The StorageOS cluster operator is a [Kubernetes native
application](https://kubernetes.io/docs/concepts/extend-kubernetes/extend-cluster/)
developed to deploy and configure StorageOS clusters, and assist with
maintenance operations.

The operator acts as a Kubernetes controller that watches the `StorageOSCluster`
CR. Once the controller is ready, a StorageOS cluster definition can be
created. The operator will deploy a StorageOS cluster based on the
configuration specified in the cluster definition.

You can find the source code in the [cluster-operator
repository](https://github.com/storageos/cluster-operator).


Follow these steps to deploy a StorageOS cluster with the `Cluster Operator`.

## 1. Install operator

To install the operator follow the installation page for your orchestrator.

1. [Kubernetes]({%link _docs/platforms/kubernetes/install/index.md %})
1. [OpenShift]({%link _docs/platforms/openshift/install/index.md %})

## 2. Create Secret
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

## 3. Create a CR to deploy StorageOS

Create a `cluster-config.yaml` according to your needs from the
[examples]({%link _docs/reference/cluster-operator/examples.md %}).
section of the Cluster Operator.

```bash
CR_DEFINITION= # Your CR file based on examples from this DIR
kubectl create -f $CR_DEFINITION
```

Even the CR.yaml file is deployed in a different NS, StorageOS will be deployed
in the `storageos` NameSpace.

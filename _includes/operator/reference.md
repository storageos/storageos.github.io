# Cluster Operator

Our cluster operator is a [Kubernetes native
application](https://kubernetes.io/docs/concepts/extend-kubernetes/extend-cluster/)
developed to deploy and configure StorageOS clusters, and assist with
maintenance operations. We recommend its use for standard installations. 

The operator acts as a Kubernetes controller that watches the `StorageOSCluster`
CR (Custom Resource). Once the controller is ready, a StorageOS cluster definition can be
created. The operator will deploy a StorageOS cluster based on the
configuration specified in the cluster definition.

You can find the source code in the [cluster-operator
repository](https://github.com/storageos/cluster-operator).

Install the operator following orchestrator specific procedure.

To deploy a StorageOS cluster you will need to fulfil the following steps.

1. Install operator
1. Create `storageos-api` Secret
1. Create a CR (Custom Resource) to deploy StorageOS


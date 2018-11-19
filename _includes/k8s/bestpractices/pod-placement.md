## StorageOS Pod placement

StorageOS must run on all nodes that will contribute storage capacity to the
cluster or that will host Pods which use StorageOS volumes. For production
environments, it is recommended to avoid placing StorageOS Pods on Master
nodes.

StorageOS is deployed with a DaemonSet controller, and therefore tolerates the
standard unschedulable taint placed on master nodes, and cordoned nodes (see
the Kubernetes
[docs](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)
for more details). To avoid scheduling StorageOS pods on master nodes, you can
add an arbitrary taint to them for which the StorageOS DaemonSet won't have a
toleration.

Be sure to appropriately modify the [JOIN]({%link
_docs/prerequisites/clusterdiscovery.md %}) variable defined for the DaemonSet
to avoid newly bootstrapping nodes trying to contact non-existent pods on
Master nodes. If installing with our [Cluster Operator]({% link
_docs/reference/cluster-operator/index.md %}), this is handled for you automatically.

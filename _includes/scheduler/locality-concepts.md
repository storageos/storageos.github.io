StorageOS has the capacity to influence Kubernetes Pod placement decisions to
ensure that Pods are scheduled on the same nodes as their data. This
functionality is known as `Pod Locality`.

StorageOS grants access to data by presenting, on local or remote nodes, the
devices used in a Pod's VolumeMounts. However, it is often the case that it is
required or preferred to place the Pod on the node where the StorageOS Primary
Volume is located, because IO operations are fastest as a result of minimized
network traffic and associated latency. Read operations are served locally and
writes require fewer round trips to the replicas of the volume.

StorageOS automatically enables the use of a custom scheduler for any Pod
using StorageOS Volumes. Checkout the [Admission Controller
reference]({% link _docs/reference/scheduler/admission-controller.md %}) for more
information.


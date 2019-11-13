## Admission Controller

StorageOS implements an [admission
controller](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/#what-are-they)
that ensures any Pod using StorageOS Volumes are scheduled by the StorageOS
Scheduler. This makes the use of the scheduler transparent to the user. Check
the [reference page]({% link _docs/reference/scheduler/admission-controller.md
%}) to see how to alter this behaviour.

The Admission Controller is based on admission webhooks. Therefore, no custom
admission plugins need to be enabled at bootstrap of your Kubernetes cluster.
Admission webhooks are HTTP callbacks that receive admission requests and do
something with them. The StorageOS Cluster Operator serves the admission
webhook. So when a Pod is in the process of being created, the StorageOS
Cluster Operator mutates the `spec.schedulerName` ensuring the
`storageos-scheduler` is set.

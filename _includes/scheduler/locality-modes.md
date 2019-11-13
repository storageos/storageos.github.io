## Locality modes

There are two modes available to set pod locality for StorageOS Volumes.

### Preferred

The Pod SHOULD be placed alongside its data, if possible. Otherwise, it will be
placed alongside volume replicas. If neither scenario is possible, the Pod
will start on another node and StorageOS will grant access to the
data over the network.

Preferred mode is the default behaviour when using the StorageOS scheduler.

### Strict

The Pod MUST be placed alongside its data, i.e. on a node with the master
volume or a replica. If that is not possible, the Pod will remain in pending
state until the premise can be fulfilled.

The aim of strict mode is to provide the user with the capability to guarantee
best performance for applications. Some applications are required to give a
certain level of performance, and for such applications strict co-location of
application and data is essential.

For instance, when running Kafka Pods under heavy load, it may be better to
avoid scheduling a Pod using a remote volume rather than have clients
direct traffic at a cluster member which exhibits degraded performance.


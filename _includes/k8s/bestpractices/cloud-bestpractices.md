## StorageOS in Cloud Environments

Cloud environments give the user the ability to scale out and scale down the
number of nodes in the cluster at a fast peace. Because of the ephemeral nature
of the cloud, StorageOS recommends to set conservative downscaling policies.

For production clusters, it recommended to use dedicated instance groups for
Stateful applications that allow the user to set different scaling policies and
define StorageOS pools based on node selectors to collocate volumes.

Loosing a few nodes at the same time could cause the lost of data even when
having volume replicas.

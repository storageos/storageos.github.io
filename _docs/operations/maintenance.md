---
layout: guide
title: StorageOS Docs - Maintenance
anchor: operations
module: operations/maintenance
---

# Maintenance

## Upgrade

It is recommended to drain a node before any maintenance operation. Executing a
node drain will move any active volumes from the node and re-schedule them on
other nodes in a cluster. This operation will take longer for large volumes.

You can either [cordon or drain](/docs/reference/cli/node) a node using the [StorageOS cli](/docs/reference/cli/index).

A `storageos node cordon` will avoid any new volumes to be hosted in that node. On the other hand, a `storageos node drain` will evict all volumes from the node and will prevent any new volumes to be hosted, as well.


####  Hosting primary volumes with replication enabled:

- Existing replicas will be promoted in different nodes
- The previous primary will become a replica.
- The replica is relocated to a different node

#### Hosting primary volumes with replication *not enabled*:

- A replica will be created in a different available node
- The new replica will be promoted to primary
- The old primary volume will be removed


#### If there are no available nodes free

There are a variety of reasons why a volume cannot be hosted by a node. For
instance, because there are rules in place that define restrictions of location,
or because the amount of replicas +1 match the amount of nodes in the cluster.

- A replica will be promoted to primary
- The old primary will become a replica
- The replica will remain in the drained node till a free node becomes available


If you find yourself in the situation where the volumes can't be relocated, you
can add one or more nodes to the StorageOS cluster. By doing so, the volumes
will be moved automatically as soon as they become available. While a node is in
a drain state, it will keep trying to evict all its volumes. You can stop an
eviction process by undraining the node.

Performing a node drain will not remove the StorageOS mounts living in that
node. Any volume mounted in that specific node will be evicted but still hold
the StorageOS mount making the data transparently available to the client, with
zero downtime.

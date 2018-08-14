---
layout: guide
title: StorageOS Docs - Maintenance
anchor: concepts
module: concepts/maintenance
---

# Maintenance

## Scaling

A StorageOS cluster can scale horizontally by adding more nodes to a
cluster, or vertically by adding more storage to individual nodes in a cluster.

To add a node to an existing cluster, run the StorageOS container with `JOIN`
set to the IP addresses of one of the nodes.

It is possible to use different disks or partitions to expand StorageOS'
available space. StorageOS needs a filesystem formatted and mounted to
`/var/lib/storageos/data` and by default, the directory
`/var/lib/storageos/data/dev1` will be created when volumes are used.

However, it is possible to shard the data files by creating more directories.
StorageOS will save data in any directory that follows the name `dev[0-9]+`,
such as `/var/lib/storageos/data/dev2` or `/var/lib/storageos/data/dev5`. This
functionality enables operators to mount different devices into devX directories
and StorageOS will recognise them as available storage automatically.

## Node maintenance

Before rebooting or upgrading a node, you should put the node in maintenance
mode by draining the node. This will reschedule volumes to other nodes and
mark the node as unschedulable.

* If the volume does not have replicas, a new replica will be created on a
different node and promoted to master. The previous master will be removed.

* If the volume has replicas, one will be promoted to master. The previous master
will become a replica and be relocated to a different node.

* If there are not enough available nodes, StorageOS will keep trying to evict all
volumes while the node is in the drained state. Once a new node is added to the
cluster, the volume will be moved automatically.

Performing a node drain will not remove the StorageOS mounts living in that
node. Any volume mounted in that specific node will be evicted but still hold
the StorageOS mount making the data transparently available to the client, with
zero downtime.

>**Warning**: It is currently not possible for a node to leave the cluster
*completely. If the StorageOS container is stopped and/or removed from a node
*then the node will be detected as failed and it will be marked offline, but
*there is no way to remove the node from the list. The next release will provide
*functionality to cleanly remove a node.

## Backups and upgrades

Before upgrading, check the release notes to confirm whether there is a safe
upgrade path between versions.

Upgrades can be performed by restarting the StorageOS node container with the
new version.

Backups are coming soon.

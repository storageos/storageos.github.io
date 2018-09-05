---
layout: guide
title: StorageOS Docs - Highly available volumes
anchor: concepts
module: concepts/havolumes
---

# High Availability

StorageOS replicates volumes across nodes for data protection and high
availability. Synchronous replication ensures strong consistency for
applications such as databases and Elasticsearch, incurring one network round
trip on writes.

The basic model for StorageOS replication is of a master volume with distributed
replicas. Each volume can be replicated between 0 and 5 times, which are
provisioned to 0 to 5 nodes, up to the number of remaining nodes in the cluster.

In this diagram, the master volume `D` was created on node 1, and two replicas,
`D2` and `D3` on nodes 3 and 5.

![StorageOS replication](/images/docs/concepts/high-availability.png)

Writes that come into `D` (step 1) are written in parallel to `D2` and `D3`
(step 2). When both replicas and the master acknowledge that the data has been
written (step 3), the write operation return successfully to the application
(step 4).

For most applications, one replica is sufficient (`storageos.com/replicas=1`).

## Network Traffic

All replication traffic on the wire is compressed using the lz4 algorithm, then
streamed over tcp/ip to target port tcp/5703.

## Failover

If the master volume is lost, a random replica is promoted to master (`D2` or
`D3` above) and a new replica is created and synced on an available node (Node 2
or 4). This is transparent to the application and does not cause downtime.

If a replica volume is lost and there are enough remaining nodes, a new replica
is created and synced on an available node. While a new replica is created and
being synced, the volume's health will be marked as degraded and the failure
mode will determine whether the volume can be used during recovery:

| Failure mode       | On loss of replica   | Example |
|:-------------------|:---------------------| --------|
| Hard               | If the number of replicas falls below that requested, mark the volume as unavailable. Any reads or writes will fail. |`storageos.com/failure.mode=hard` |
| Always On           | As long as any copy of the volume is available, the volume will be usable.                   |`storageos.com/failure.mode=alwayson` |
| Soft               | Default mode. Specify how many failed replicas to tolerate, defaulting to 1 if there is only 1 replica, or replicas - 1 if there is more than 1 replica.                  |`storageos.com/failure.mode=soft storageos.com/failure.tolerance=2` |

## Enforcing replication policies

While replica count and replication failure mode are controllable on a
per-volume basis, some environments may prefer to set appropriate policies to
ensure a desired level of data protection. This can be accomplished on a
per-namespace basis  using
[Rules]({%link _docs/operations/rules.md %}).

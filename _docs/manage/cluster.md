---
layout: guide
title: StorageOS Docs - Cluster
anchor: manage
module: manage/cluster
---

# Cluster overview

A StorageOS cluster needs to know the exact cluster size and peers to connect to
during start up. All the nodes need to bind to the correct addresses in order to
peer correctly. To override the default (the first non-loop interface), you can
set the `ADVERTISE_IP` environment variable:

```bash
export ADVERTISE_IP=172.28.128.3
```

<!--
## Cluster discovery

The StorageOS discovery service makes it easy to form a cluster using a token, which is supplied to each node. This is available through the [StorageOS CLI](link /_docs/reference/cli).

To get a token:
```bash
$ storageos cluster create
cluster token: 017e4605-3c3a-434d-b4b1-dfe514a9cd0f
```

Supply this cluster ID to all the nodes that you want to join the cluster:
```bash
CLUSTER_ID=017e4605-3c3a-434d-b4b1-dfe514a9cd0f
```

Each node will report that it is waiting for the cluster. Once enough members
are registered, StorageOS will start up.

Alternatively, you can supply the `INITIAL_CLUSTER` environment variable:

```bash
INITIAL_CLUSTER=storageos-1=http://172.28.128.3:2380,storageos-2=http://172.28.128.9:2380,storageos-3=http://172.28.128.15:2380
```
-->

## Pools

StorageOS manages storage using pools, which are collections of storage resouces
created from StorageOS cluster nodes. Most users will use the default pool.

Pools are used to organize storage resources into common collections such as
class of server, class of storage, location within the datacenter or subnet.
Cluster nodes can participate in more than one pool.

Volumes are provisioned from pools.  If a pool name is not specified when the
volume is created, the default pool name (`default`) will be used.

[Create and manage pools with the CLI](link /_docs/reference/cli/pool)

## Namespaces

Namespaces help different projects or teams share a StorageOS cluster. No
namespaces are created by default, and users can have any number of namespaces.

Namespaces apply to volumes and rules.

>**Note**: Docker does not support namespaces, so you should avoid mixing
volumes created by `docker volume create` (which does not allow namespaces) with
volumes created by `storageos volume create` (which requires a namespace).

[Create and manage namespaces with the CLI](link /_docs/reference/cli/namespace)

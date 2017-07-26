---
layout: guide
title: StorageOS Docs - Pools
anchor: manage
module: manage/cluster/pools
---

# Pools

Pools are used to create collections of storage resources created from StorageOS
cluster nodes.

Pools are used to organize storage resources into common collections such as
class of server, class of storage, location within the datacenter or subnet.
Cluster nodes can participate in more than one pool.

## Using pools

Volumes are provisioned from pools.  If a pool name is not specified when the
volume is created, the default pool name (`default`) will be used.

To create and manage pools individually, use the [storageos pool command]({%
link _docs/reference/cli/pool.md %}) to manage which nodes participate in the
pool (via controllers) and the drivers to use.

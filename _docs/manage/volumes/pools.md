---
layout: guide
title: StorageOS Docs - Pools
anchor: manage
module: manage/volumes/pools
---

# Pools

Pools are used to create collections of storage resources created from StorageOS
cluster nodes.

Volumes are provisioned from pools.  If a pool name is not specified when the
volume is created, the default pool name (`default`) will be used.

## Using pools

Pools are used to organize storage resources into common collections such as
class of server, class of storage, location within the datacenter or subnet.
Cluster nodes can participate in more than one pool.

To create and manage pools individually, use the [storageos pool command]({%
link _docs/reference/cli/pool.md %}) to manage which nodes participate in the
pool (via controllers) and the drivers to use.

The pool cli command make use of [label selectors]({%
link _docs/manage/volumes/labels.md %}), which work in the same manner as [Kubernetes selectors](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#label-selectors).

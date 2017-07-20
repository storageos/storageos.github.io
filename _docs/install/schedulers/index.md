---
layout: guide
title: StorageOS Docs - Schedulers
anchor: install
module: install/schedulers
---

# Schedulers

StorageOS can be installed in a container/orchestrator environment using a
scheduler such as Kubernetes. The StorageOS container needs to be installed on
every node in the cluster that provides or consumes storage.

StorageOS requires a [key-value store]({% link _docs/install/kvstore/index.md %})
for cluster configuration. Ensure that you have a KV store such as Consul
running before you install StorageOS.

For replication and HA, a minimum of three nodes is required for quorum.

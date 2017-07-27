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

For replication and HA, a minimum of three nodes is required for quorum.

## Prerequisites

Ensure you read [the prerequisites]({% link _docs/install/prerequisites/index.md %}) before installing StorageOS on a cluster.

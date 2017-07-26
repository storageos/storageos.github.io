---
layout: guide
title: StorageOS Docs - Prerequisites
anchor: install
module: install/prerequisites/index
---

# Prerequisites

The minimum requirements for a StorageOS node are

* 64-bit Linux
* Docker 1.10
* A [key-value store]({% link _docs/install/prerequisites/kvstore.md %}) for configuration data and cluster management.
* A mechanism for [cluster discovery]({% link _docs/install/prerequisites/clusterdiscovery.md %}), which allows StorageOS nodes to contact each other.

While it is not mandatory, enabling the [Network Block Device module]({% link _docs/install/prerequisites/nbd.md %}) improves performance significantly.

This allows you to install StorageOS using a [container orchestrator]({% link _docs/install/schedulers/index.md %}) or with [Docker only]({% link _docs/install/docker/index.md %}).

For replication and HA, a minimum of three nodes is required for quorum.

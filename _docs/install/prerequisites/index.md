---
layout: guide
title: StorageOS Docs - Prerequisites
anchor: install
module: install/prerequisites/index
---

# Prerequisites

The following conditions must be met before installing StorageOS:

1. Linux with a 64-bit architecture
 * Ubuntu is recommended.
 * Red Hat Enterprise Linux support is coming soon.
1. Docker 1.10 or later
1. The following ports should be open:
  * 2380 for cluster discovery
  * 5705 for the StorageOS API
1. A [key-value store]({% link _docs/install/prerequisites/kvstore.md %}) for configuration data and cluster management.
1. A mechanism for [cluster discovery]({% link _docs/install/prerequisites/clusterdiscovery.md %}), to allow StorageOS nodes to contact each other.
1. For replication and HA, a minimum of three nodes is required for quorum.

While it is not mandatory, enabling the [Network Block Device module]({% link _docs/install/prerequisites/nbd.md %}) improves performance significantly.

This allows you to install StorageOS using a [container orchestrator]({% link _docs/install/schedulers/index.md %}) or with [Docker only]({% link _docs/install/docker/index.md %}).

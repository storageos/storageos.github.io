---
layout: guide
title: StorageOS Docs - Prerequisites
anchor: install
module: install/prerequisites/index
---

# Prerequisites

StorageOS has two mandatory requirements:

1. A [key-value store]({% link _docs/install/prerequisites/kvstore.md %}) for configuration data and cluster management.
2.  A mechanism for [cluster discovery]({% link _docs/install/prerequisites/clusterdiscovery.md %}), which allows StorageOS nodes to contact each other.

You should also enable the [Network Block Device module]({% link _docs/install/prerequisites/nbd.md %}) on each node, which improves performance significantly.

---
layout: guide
title: StorageOS Docs - Prerequisites
anchor: prerequisites
module: prerequisites/overview
---

# Prerequisites

Minimum requirements:

1. Minimum one core with 2GB RAM.
1. Linux with a 64-bit architecture.
1. Docker 1.10 or later, with mount propagation enabled and preferably `CHANNEL=stable`
1. The necessary ports should be open. See the [ports and firewall settings]({% link _docs/prerequisites/firewalls.md %})
1. A mechanism for [cluster
discovery]({% link _docs/prerequisites/clusterdiscovery.md %}), to allow
StorageOS nodes to contact each other.
1. A mechanism for [device presentation]({% link _docs/prerequisites/devicepresentation.md %})

Recommended:

1. At least three nodes for replication and high availability.
1. [Install the storageos CLI]({% link _docs/reference/cli/index.md %}).

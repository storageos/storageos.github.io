---
layout: guide
title: StorageOS Docs - Prerequisites
anchor: prerequisites
module: prerequisites/overview
---

# Prerequisites

## Minimum requirements:

One machine with the following:

1. Minimum one core with 2GB RAM.
1. Linux with a 64-bit architecture.
1. Docker 1.10 or later, with [mount propagation]({% link _docs/prerequisites/mountpropagation.md %}) enabled and preferably `CHANNEL=stable`
1. The necessary ports should be open. See the [ports and firewall settings]({% link _docs/prerequisites/firewalls.md %})
1. A mechanism for [device presentation]({% link
   _docs/prerequisites/systemconfiguration.md %})


## Recommended:

1. At least three nodes for replication and high availability.
1. [Install the storageos CLI]({% link _docs/reference/cli/index.md %}).
1. If using Helm, make sure the tiller ServiceAccount has enough privileges to
   create resources such as Namespaces, ClusterRoles, etc. For instance, following this [installation
   procedure](https://github.com/helm/helm/blob/master/docs/rbac.md#example-service-account-with-cluster-admin-role).
1. System clocks synchronized using NTP or similar methods. While our
   distributed consensus algorithm does not require synchronised clocks, it
   does help to more easily correlate logs across multiple nodes.

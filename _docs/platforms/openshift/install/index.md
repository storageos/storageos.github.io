---
layout: guide
title: StorageOS Docs - OpenShift
anchor: platforms
module: platforms/openshift/install
---

# OpenShift

This section of documentation covers use of the [OpenShift](https://www.openshift.com/) orchestrator
from Red Hat. The StorageOS installation procedure is slightly different depending on the version
you have deployed, so follow the appropriate guide. Other documents in this section are version
agnostic.

## OpenShift with StorageOS

OpenShift and StorageOS communicate to each other to perform actions such as
create, delete or mount volumes. The standard communication procedure uses REST
API calls. However, StorageOS also implements communication using CSI. By 
using CSI, OpenShift and StorageOS communicates via a Linux socket. That
socket is handled by the Kubelet in the Host.

## CSI (Container Storage Interface) Note

CSI is the future standard that enables storage drivers to release on their own
schedule. This allows storage vendors to upgrade, update, and enhance their drivers 
without the need to update Kubernetes source code, or follow Kubernetes release
cycles.

CSI is in "Technology Preview and not for production workloads" in OpenShift.
As CSI is still not GA version, StorageOS recommends it is only used if
the user is aware of its limitations and understands that non-GA versions of an
active project might contain breaking changes.

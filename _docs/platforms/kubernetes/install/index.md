---
layout: guide
title: StorageOS Docs - Kubernetes
anchor: platforms
module: platforms/kubernetes/install
---

# Kubernetes

This section of documentation covers use of the vanilla [kubernetes]
(https://kubernetes.io/) orchestrator. The StorageOS installation procedure is
slightly different depending on the version you have deployed, so follow the
appropriate guide. Other documents in this section are version agnostic.

## Kubernetes with StorageOS

Kubernetes and StorageOS communicate to each other to perform actions such as
create, delete or mount volumes. The standard communication procedure uses REST
API calls. However, StorageOS also implements communication using CSI. By 
using CSI, Kubernetes and StorageOS communicates via a Linux socket. That
socket is handled by the Kubelet in the Host.

## CSI (Container Storage Interface) Note

CSI is the future standard that enables storage drivers to release on their
schedule. This allows storage vendors to upgrade, update, and enhance their
drivers without the need to update Kubernetes source code, or follow
Kubernetes release cycles.

CSI is available from Kubernetes 1.9 alpha. Because CSI is still not GA in
Kubernetes, StorageOS recommends only its use if the user is aware of its
limitations and understands that non-GA versions of an active project
might contain breaking changes.

Check out the status of the CSI release cycle in relation with Kubernetes in
the [CSI project](https://kubernetes-csi.github.io/docs/) page.

StorageOS leverages labels in PVCs to apply [features]
({%link_docs/reference/labels.md %}) to StorageOS volumes. However, StorageOS
doesn't have these labels set when using CSI. Therefore, default feature labels
(`storageos.com/*`) must be defined on the Kubernetes StorageClass parameters.
Multiple StorageClasses can be defined with different parameters. The [StorageOS
cli]({%link_docs/reference/cli/index.md %}) can also manipulate volume labels
or create [rules]({%link _docs/reference/cli/rule.md %}) to add/delete labels
on StorageOS volumes.

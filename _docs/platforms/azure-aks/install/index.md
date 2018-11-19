---
layout: guide
title: StorageOS Docs - Azure
anchor: platforms
module: platforms/azure-aks/install
---

# AKS

This section of documentation covers the installation of StorageOS in the
managed Kubernetes Azure service
[AKS](https://azure.microsoft.com/en-gb/services/kubernetes-service/). For the
installation of StorageOS with vanilla Kubernetes in Azure VMs, visit the
[Kubernetes standard installation]({%link
_docs/platforms/kubernetes/install/index.md %}) procedure.


## AKS and StorageOS

AKS deployment of Kubernetes uses Ubuntu by default with a kernel optimized.
All versions of Ubuntu with the kernel version post `4.15.0-1029-azure` meets
the StorageOS prerequisites by default.

## Best practices

Visit the [best practices] section to install StorageOS for production
clusters.

## Kubernetes with StorageOS

Kubernetes and StorageOS communicate with each other to perform actions such as
create, delete or mount volumes. StorageOS implements communication using CSI. By
using CSI, Kubernetes and StorageOS communicate over a Unix domain socket. That
socket is handled by the Kubelet in the Host.

## CSI (Container Storage Interface) Note

CSI is the future standard that enables storage drivers to release on their own
schedule. This allows storage vendors to upgrade, update, and enhance their drivers 
without the need to update Kubernetes source code, or follow Kubernetes release
cycles.

StorageOS communicates with AKS Kubernetes Master nodes using only CSI.

Check out the status of the CSI release cycle in relation with Kubernetes in
the [CSI project](https://kubernetes-csi.github.io/docs/) page.

StorageOS leverages labels in PVCs to apply [features]
({%link _docs/reference/labels.md %}) to StorageOS volumes. However, StorageOS
doesn't have these labels set when using CSI. Therefore, default feature labels
(`storageos.com/*`) must be defined on the Kubernetes StorageClass parameters.
Multiple StorageClasses can be defined with different parameters. The [StorageOS
CLI]({%link _docs/reference/cli/index.md %}) can also manipulate volume labels
or create [rules]({%link _docs/reference/cli/rule.md %}) to add/delete labels
on StorageOS volumes.

---
layout: guide
title: StorageOS Docs - Azure
anchor: platforms
module: platforms/azure-aks
---

# AKS

This section of documentation covers the use of the managed Kubernetes Azure
service [AKS](https://azure.microsoft.com/en-gb/services/kubernetes-service/).
For information on the installation of StorageOS with vanilla Kubernetes in Azure
VMs, please refer to the [Kubernetes standard installation]({%link
_docs/platforms/kubernetes/install/index.md %}) procedure.

AKS deployment of Kubernetes uses Ubuntu by default with an optimized kernel.
All versions of Ubuntu with a kernel version later than`4.15.0-1029-azure`
meet the StorageOS prerequisites.

## Kubernetes with StorageOS

Kubernetes and StorageOS communicate with each other to perform actions such as
creation, deletion or mounting of volumes. StorageOS implements communication 
using CSI. By using CSI, Kubernetes and StorageOS communicate over a Unix domain
socket, handled by the Kubelet on the Host.

## CSI (Container Storage Interface) Note

CSI is the new standard that enables storage drivers to release on their own
schedule. This allows storage vendors to upgrade, update, and enhance their drivers 
without the need to update Kubernetes source code, or follow Kubernetes release
cycles.

StorageOS communicates with AKS Kubernetes Master nodes using CSI only.

Check out the status of the CSI release cycle in relation to Kubernetes on
the [CSI project](https://kubernetes-csi.github.io/docs/) page.

StorageOS leverages labels on PVCs to apply [features]({%link
_docs/reference/labels.md %}) to StorageOS volumes. However, StorageOS doesn't
have these labels set when using CSI. Therefore, default feature labels
(`storageos.com/*`) must be defined on the Kubernetes StorageClass parameters.
Multiple StorageClasses can be defined with different parameters. The
[StorageOS CLI]({%link _docs/reference/cli/index.md %}) can also manipulate
volume labels or create [rules]({%link _docs/reference/cli/rule.md %}) to
add/delete labels on StorageOS volumes.

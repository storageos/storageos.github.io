---
layout: guide
title: StorageOS Docs - Azure
anchor: platforms
module: platforms/azure-aks/install
---

# AKS

This section of documentation covers the use of the managed Kubernetes Azure
service [AKS](https://azure.microsoft.com/en-gb/services/kubernetes-service/).
For information on the installation of StorageOS with vanilla Kubernetes in Azure
VMs, please refer to the [Kubernetes standard installation]({%link
_docs/platforms/kubernetes/install/index.md %}) procedure.


## AKS and StorageOS

AKS deployment of Kubernetes uses Ubuntu by default with an optimized kernel.
All versions of Ubuntu with a kernel version later than `4.15.0-1029-azure`
meets the StorageOS prerequisites.

## Best practices

Visit the [best practices]({%link
_docs/platforms/azure-aks/bestpractices/index.md %}) section to install
StorageOS for production clusters.

## Kubernetes with StorageOS

Kubernetes and StorageOS communicate with each other to perform actions such as
creation, deletion or mounting volumes. It is required to use the CSI
(Container Storage Interface) driver for StorageOS installations on AKS. When
using CSI, Kubernetes and StorageOS communicate over a Unix domain socket. This
socket is handled by the Kubelet in the Host.

## CSI (Container Storage Interface) Note

CSI is the de facto standard that enables storage drivers to release on their
own schedule. This allows storage vendors to upgrade, update, and enhance their
drivers without the need to update Kubernetes source code, or follow Kubernetes
release cycles.

CSI is available from Kubernetes 1.9 alpha. CSI is considered GA from
Kubernetes 1.13, hence StorageOS recommends the use of CSI. In addition, the
StorageOS Cluster Operator handles the versioning of the API complexity by
detecting the Kubernetes installed and setting up the appropriate CSI driver.

Check out the status of the CSI release cycle in relation with Kubernetes in
the [CSI project](https://kubernetes-csi.github.io/docs/) page.

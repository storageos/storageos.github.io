---
layout: guide
title: StorageOS Docs - Kubernetes
anchor: platforms
module: platforms/kubernetes/install
---

# Kubernetes

This section of documentation covers use of the vanilla [kubernetes](https://kubernetes.io/) 
orchestrator. The StorageOS installation procedure is slightly different depending 
on the version you have deployed, so follow the appropriate guide. Other documents
in this section are version agnostic.

## Kubernetes with StorageOS

Kubernetes and StorageOS communicate with each other to perform actions such as
creation, deletion or mounting volumes. The former communication procedure, although still in use, uses REST
API calls. StorageOS still maintains support for it. However, it is recommended
to use the CSI (Container Storage Interface) driver for the communication. By
using CSI, Kubernetes and StorageOS communicate over a Unix domain socket. That
socket is handled by the Kubelet in the Host.

## CSI (Container Storage Interface) Note

CSI is the de facto standard that enables storage drivers to release on their own
schedule. This allows storage vendors to upgrade, update, and enhance their drivers 
without the need to update Kubernetes source code, or follow Kubernetes release
cycles.

CSI is available from Kubernetes 1.9 alpha. CSI is considered GA from
Kubernetes 1.13, hence StorageOS recommends the use of CSI. In addition, the
StorageOS Cluster Operator handles the versioning of the API complexity by
detecting the Kubernetes installed and setting up the appropriate CSI driver.

Check out the status of the CSI release cycle in relation with Kubernetes in
the [CSI project](https://kubernetes-csi.github.io/docs/) page.

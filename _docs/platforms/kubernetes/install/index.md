---
layout: guide
title: StorageOS Docs - Kubernetes
anchor: platforms
module: platforms/kubernetes/install
---

# Kubernetes

This section of documentation covers use of the vanilla
[kubernetes](https://kubernetes.io/) orchestrator. The StorageOS installation
procedure is slightly different depending on the version you have deployed, so
follow the appropriate guide. Other documents in this section are version
agnostic.

## Kubernetes with StorageOS

Kubernetes and StorageOS communicate with each other to perform actions such as
creation, deletion or mounting of volumes. The CSI (Container Storage Interface)
driver is the standard communication method. Using CSI, Kubernetes and
StorageOS communicate over a Unix domain socket.

The former communication procedure, although still in use, uses REST
API calls. StorageOS still maintains support for it.

## CSI (Container Storage Interface) Note

CSI is the standard method of communication that enables storage drivers to
release on their own schedule. This allows storage vendors to upgrade, update,
and enhance their drivers without the need to update Kubernetes source code, or
follow Kubernetes release cycles.

CSI is available from Kubernetes 1.9 alpha. CSI is considered GA from
Kubernetes 1.13, hence StorageOS recommends the use of CSI. In addition, the
StorageOS Cluster Operator handles the configuration of the CSI driver and its
complexity by detecting the version of the Kubernetes installed.

Check out the status of the CSI release cycle in relation with Kubernetes in
the [CSI project](https://kubernetes-csi.github.io/docs/) page.

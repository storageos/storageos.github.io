---
layout: guide
title: StorageOS Docs - Rancher
anchor: platforms
module: platforms/rancher/install
---

# Rancher

This section of documentation covers use of the [Rancher](https://www.rancher.com/) orchestrator
as a Kubernetes provisioner.

## Rancher with StorageOS

StorageOS installation in Rancher is fully supported.

Kubernetes API controller and StorageOS communicate to each other to perform actions such as
create, delete or mount volumes. The standard communication procedure uses REST
API calls. However, StorageOS also implements communication using CSI. By 
using CSI, Kubernetes and StorageOS communicates via a Linux socket. That
socket is handled by the Kubelet in the Host.

## CSI (Container Storage Interface) Note

CSI is the future standard that enables storage drivers to release on their own
schedule. This allows storage vendors to upgrade, update, and enhance their drivers 
without the need to update Kubernetes source code, or follow Kubernetes release
cycles.

CSI 1.0.0 is released with Kubernetes 1.13. Its use is recommended only if
the user is aware of its particularities. CSI communication between StorageOS
and Kubernetes is not possible at the moment when using RancherOS due to access
to the Linux Socket created by the Kubelet. CSI communication is fully
supported by StorageOS if the Kubernetes cluster is deployed with another
supported Linux Distribution.

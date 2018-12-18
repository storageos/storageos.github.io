---
layout: guide
title: StorageOS Docs - Installing on Kubernetes 1.11
platform: rancher
platformUC: Rancher
k8s-version: 1.11
cmd: kubectl
anchor: platforms
module: platforms/rancher/install/kubernetes
redirect_from: /docs/install/schedulers/rancher
redirect_from: /docs/install/rancher
---

# Rancher Kubernetes

> Make sure the 
> [prerequisites for StorageOS]({%link  _docs/prerequisites/overview.md %}) are
> satisfied before proceeding.

&nbsp;

StorageOS can interface with Kubernetes using the [native volume driver](https://kubernetes.io/docs/concepts/storage/storage-classes/#storageos) 
or the new [CSI](https://kubernetes.io/blog/2018/01/introducing-container-storage-interface/)
interface.  __For Rancher deployments, we recommend the StorageOS Operator
install using native drivers, unless you have a specific requirement.__

CSI cannot be used if Kubernetes is deployed in nodes using RancherOS. It can
be used if running in distributions such as CentOS, RHEL, Debian or Supported
Ubuntu kernels.

{% include operator/install.md %}

## CSI Note

CSI allows you to set StorageOS features (`storageos.com/*` labels)
on the StorageClass, but not on the PVC definition. If you need to set labels
on PVCs or your environment does not support CSI, you may install StorageOS
without CSI.

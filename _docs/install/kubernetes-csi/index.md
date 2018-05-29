---
layout: guide
title: StorageOS Docs - Kubernetes (CSI)
anchor: install
module: install/kubernetes-csi
---

# Install with Kubernetes

StorageOS can be used as a storage provider for your Kubernetes cluster, making
local storage accessible from any node within the Kubernetes cluster.  Data can
be replicated to protect against node failure.

At its core, StorageOS provides block storage.  You may choose the filesystem
type to install to make devices usable from within containers.

[**Try it in your browser for up to one hour >>**](https://my.storageos.com/main/tutorial/k8s-sandbox)

## Prerequisites

You will need a Kubernetes 1.10+ cluster to install StorageOS as a CSI driver.

## Install with Helm

Firstly, [install Helm](https://docs.helm.sh/using_helm).

```bash
$ git clone https://github.com/storageos/helm-chart.git storageos
$ cd storageos
$ git checkout csi-deployment
$ helm install --name my-release . --set cluster.join=<join-token/node-ip>
```

To uninstall the release with all related Kubernetes components:

```bash
$ helm delete --purge my-release
```

[See further configuration options.](https://github.com/storageos/helm-chart/tree/csi-deployment#configuration)

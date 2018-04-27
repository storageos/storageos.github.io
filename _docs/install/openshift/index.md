---
layout: guide
title: StorageOS Docs - OpenShift
anchor: install
module: install/openshift
---

# Install with OpenShift

StorageOS can be used as a storage provider for your OpenShift cluster, making
local storage accessible from any node within the OpenShift cluster.  Data can
be replicated to protect against node failure.

At its core, StorageOS provides block storage.  You may choose the filesystem
type to install to make devices usable from within containers.

## Prerequisites

You will need an OpenShift 3.8+ cluster with Beta APIs enabled.

1. Enable the `MountPropagation` flag by appending `--feature-gates
MountPropagation=true` to the kube-apiserver and kubelet services.

1. If the kubelet is running in a container, add `--volume=/var/lib/storageos:/var/lib/storageos:rshared` to each
of the kubelets. This will be [fixed](https://github.com/kubernetes/kubernetes/pull/58816) in OpenShift 3.10+.

1. The [iptables rules]({% link
_docs/install/prerequisites/firewalls.md %}) required for StorageOS.

For OpenShift 3.7, you can [install the container directly in
Docker]({%link _docs/install/docker/index.md %}).

## Install with Helm

Firstly, [install Helm](https://blog.openshift.com/getting-started-helm-openshift).

```bash
$ git clone https://github.com/storageos/helm-chart.git storageos
$ cd storageos
$ helm install --name my-release .

# Follow the instructions printed by helm install to update the link between Kubernetes and StorageOS.
$ ClusterIP=$(kubectl get svc/storageos --namespace kube-system -o custom-columns=IP:spec.clusterIP --no-headers=true)
$ ApiAddress=$(echo -n "tcp://$ClusterIP:5705" | base64)
$ kubectl patch secret/storageos-api --namespace kube-system --patch "{\"data\":{\"apiAddress\": \"$ApiAddress\"}}"
```

To uninstall the release with all related Kubernetes components:

```bash
$ helm delete --purge my-release
```

[See further configuration options.](https://github.com/storageos/helm-chart#configuration)

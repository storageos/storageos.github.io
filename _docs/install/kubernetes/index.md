---
layout: guide
title: StorageOS Docs - Kubernetes
anchor: install
module: install/kubernetes
redirect_from: /docs/install/schedulers/kubernetes
---

# Install with Kubernetes

StorageOS can be used as a storage provider for your Kubernetes cluster, making
local storage accessible from any node within the Kubernetes cluster.  Data can
be replicated to protect against node failure.

At its core, StorageOS provides block storage.  You may choose the filesystem
type to install to make devices usable from within containers.

[**Try it in your browser for up to one hour >>**](https://my.storageos.com/main/tutorial/k8s-sandbox)

## Prerequisites

You will need a Kubernetes 1.8+ cluster with Beta APIs enabled. For Kubernetes
1.7, you can [install the container directly in Docker]({%link _docs/install/docker/index.md %}).

1. Enable the `MountPropagation` flag by appending `--feature-gates
MountPropagation=true` to the kube-apiserver and kubelet services.

1. For deployments where the kubelet runs in a container (eg. [OpenShift]({%link assets/ansible.sh %}), CoreOS,
Rancher), add `--volume=/var/lib/storageos:/var/lib/storageos:rshared` to each
of the kubelets. This will be [fixed](https://github.com/kubernetes/kubernetes/pull/58816) in Kubernetes 1.10+.

1. [Enable the Network Block Device module]({% link
_docs/install/prerequisites/devicepresentation.md %}) on each node for better
performance.


## Install with Helm

Firstly, [install Helm](https://docs.helm.sh/using_helm).

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

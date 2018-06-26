---
layout: guide
title: StorageOS Docs - Mount Propagation
anchor: install
module: install/prerequisites/mountpropagation
---

# Mount Propagation

StorageOS requires mount propagation enabled to present devices as volumes for containers. According to the docker installation, that functionality may or may not be enabled by default. 

On the other hand, orchestrators such as Kubernetes or OpenShift have their own implementations. K8S 1.10 and OpenShift 3.10 have mount propagation enabled by default. 
However, prior versions require to enable feature gates in the master configuration controllers and in the kubelet service for each node. Installations of orchestrators using docker require
that mount propagation is enabled for both.

Refer to the installation pages to see details on how to check and enable mount propagation.

1. [Docker]({%link _docs/install/docker/index.md %})
1. [Kubernetes]({%link _docs/install/kubernetes/index.md %})
1. [OpenShift]({%link _docs/install/openshift/index.md %})

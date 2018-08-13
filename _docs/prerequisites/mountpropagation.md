---
layout: guide
title: StorageOS Docs - Mount Propagation
anchor: prerequisites
module: prerequisites/mountpropagation
---

# Mount Propagation

StorageOS requires mount propagation enabled to present devices as volumes for
containers. According to the docker installation, that functionality may or may
not be enabled by default.

On the other hand, orchestrators such as Kubernetes or OpenShift have their own
implementations. K8S 1.10 and OpenShift 3.10 have mount propagation enabled by
default. However, prior versions require to enable feature gates in the master
configuration controllers and in the kubelet service for each node.
Installations of orchestrators using Docker require that mount propagation is
enabled for both.

Refer to the installation pages to see details on how to check and enable mount
propagation.

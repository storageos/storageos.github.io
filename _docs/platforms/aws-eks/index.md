---
layout: guide
title: StorageOS Docs - AWS
anchor: platforms
platform: aws-eks
platform-pretty: EKS
module: platforms/aws-eks
---

# EKS

This section of documentation covers the use of the managed Kubernetes AWS
service [EKS](https://aws.amazon.com/eks/). For information on the installation
of StorageOS with vanilla Kubernetes in AWS VMs, please refer to the
[Kubernetes standard installation]({%link
_docs/platforms/kubernetes/install/index.md %}) procedure.

## EKS and StorageOS

EKS deployment of Kubernetes uses AWS Linux by default with an optimized
kernel. As the requisite kernel modules are not available for StorageOS to use
TCMU, FUSE will be used as a fallback.

{% include platforms/managedservices-upgrades.md %}
{% include platforms/kubernetes-with-storageos.md %}
{% include platforms/csi-note.md %}

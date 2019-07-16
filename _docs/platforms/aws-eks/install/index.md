---
layout: guide
title: StorageOS Docs - AWS-EKS
anchor: platforms
platform: aws-eks
platform-pretty: EKS
module: platforms/aws-eks/install
---

# EKS

This section of documentation covers the use of the managed Kubernetes AWS
service [EKS](https://aws.amazon.com/eks/).
For information on the installation of StorageOS with vanilla Kubernetes in AWS
VMs, please refer to the [Kubernetes standard installation]({%link
_docs/platforms/kubernetes/install/index.md %}) procedure.

## EKS and StorageOS

We only support EKS deployment of Kubernetes using the [AWS
Linux2](https://aws.amazon.com/amazon-linux-2/) image. AWS Ubuntu optimised
kernels have missing kernel dependencies, and are therefore not currently
supported. We are working with AWS to address this.  Check out the [systems
compatibility docuement]({%link _docs/prerequisites/systemconfiguration.md %})
for more information.

## Best practices

Visit the [best practices]({%link
_docs/platforms/aws-eks/bestpractices/index.md %}) section to install
StorageOS for production clusters.

{% include platforms/kubernetes-with-storageos.md %}
{% include platforms/csi-note.md %}

---
layout: guide
title: StorageOS Docs - Kubernetes
platform: "aws-eks"
platform-pretty: "EKS"
anchor: platforms
module: platforms/aws-eks/bestpractices
---

# StorageOS with EKS Kubernetes best practices

{% include k8s/bestpractices/dedicated-instancegroup.md %}
{% include k8s/bestpractices/etcd-external.md %}
{% include k8s/bestpractices/api-password.md %}
{% include k8s/bestpractices/storage-host-setup.md %}
{% include k8s/bestpractices/resources.md %}
{% include k8s/bestpractices/private-network.md %}

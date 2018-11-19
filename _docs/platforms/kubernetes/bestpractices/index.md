---
layout: guide
title: StorageOS Docs - Kubernetes
platform: Kubernetes
anchor: platforms
module: platforms/kubernetes/bestpractices
---

# StorageOS with {{ page.platform }} best practices

{% include k8s/bestpractices/pod-placement.md %}
{% include k8s/bestpractices/api-password.md %}
{% include k8s/bestpractices/etcd-external.md %}
{% include k8s/bestpractices/storage-host-setup.md %}
{% include k8s/bestpractices/resources.md %}
{% include k8s/bestpractices/private-network.md %}

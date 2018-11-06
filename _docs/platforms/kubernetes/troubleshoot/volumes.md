---
layout: guide
title: StorageOS Docs - Kubernetes troubleshoot
anchor: platforms
cmd: kubectl
platform: Kubernetes
module: platforms/kubernetes/troubleshoot/volumes
---

# Troubleshooting

{% include troubleshoot/index-{{ page.platform | downcase }}-volume-issues.md %}

{% include troubleshoot/issues/mount-in-pod-stat.md %}
{% include troubleshoot/issues/pvc-pending-fail-to-dial.md %}
{% include troubleshoot/issues/pvc-pending-missing-secret.md %}

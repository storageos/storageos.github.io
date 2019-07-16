---
layout: guide
title: StorageOS Docs - rancher troubleshoot
anchor: platforms
cmd: kubectl
platform: Rancher
platform-pretty: "Rancher"
module: platforms/rancher/troubleshoot/volumes
---

# Troubleshooting

{% include troubleshoot/index-{{ page.platform | downcase }}-volume-issues.md %}

{% include troubleshoot/issues/mount-in-pod-stat.md %}
{% include troubleshoot/issues/pvc-pending-fail-to-dial.md %}
{% include troubleshoot/issues/pvc-pending-missing-secret.md %}


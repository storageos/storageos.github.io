---
layout: guide
title: StorageOS Docs - Kubernetes troubleshoot
anchor: platforms
cmd: kubectl
platform: Kubernetes
module: platforms/kubernetes/troubleshoot/install
---

# Troubleshooting

{% include troubleshoot/index-{{ page.platform | downcase  }}-install-issues.md %}

{% include troubleshoot/common-install.md %}
{% include troubleshoot/issues/join-to-master-node.md %}
{% include troubleshoot/issues/lio-init.md %}
{% include troubleshoot/issues/lio-dataplane.md %}

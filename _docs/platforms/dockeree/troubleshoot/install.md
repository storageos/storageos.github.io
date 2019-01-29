---
layout: guide
title: StorageOS Docs - Rancher troubleshoot
anchor: platforms
cmd: kubectl
platform: Rancher
module: platforms/rancher/troubleshoot/install
---

# Troubleshooting

{% include troubleshoot/index-{{ page.platform | downcase }}-install-issues.md %}

{% include troubleshoot/issues/cr-create-no-action.md %}
{% include troubleshoot/issues/nopods-in-daemonset.md %}
{% include troubleshoot/common-install.md %}
{% include troubleshoot/issues/join-to-master-node.md %}
{% include troubleshoot/issues/scc-missing.md %}
{% include troubleshoot/issues/lio-init.md %}
{% include troubleshoot/issues/lio-dataplane.md %}

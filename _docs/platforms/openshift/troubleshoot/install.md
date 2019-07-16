---
layout: guide
title: StorageOS Docs - OpenShift troubleshoot
anchor: platforms
cmd: oc
platform: OpenShift
platform-pretty: "OpenShift"
module: platforms/openshift/troubleshoot/install
---

# Troubleshooting

{% include troubleshoot/index-{{ page.platform | downcase }}-install-issues.md %}

{% include troubleshoot/common-install.md %}
{% include troubleshoot/issues/join-to-master-node.md %}
{% include troubleshoot/issues/scc-missing.md %}
{% include troubleshoot/issues/lio-init.md %}
{% include troubleshoot/issues/lio-dataplane.md %}

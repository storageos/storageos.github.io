---
layout: guide
title: StorageOS Docs - OpenShift
platform-pretty: "OpenShift"
anchor: platforms
module: platforms/openshift/install
---

# OpenShift

This section of documentation covers use of the
[OpenShift](https://www.openshift.com/) orchestrator from Red Hat. The
StorageOS installation procedure is slightly different depending on the version
you have deployed, so follow the appropriate guide. Other documents in this
section are version agnostic.

StorageOS integrates transparently with OpenShift. The user can provide
standard PVC definitions and StorageOS will dynamically provision them.
StorageOS presents volumes to containers with standard POSIX mount targets.
This enables the Kubelet to mount StorageOS volumes using standard linux device
files. Checkout [device presentation]({%link
_docs/prerequisites/systemconfiguration.md %}) for more details.


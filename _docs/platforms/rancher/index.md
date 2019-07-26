---
layout: guide
title: StorageOS Docs - Rancher
platform-pretty: "Rancher"
anchor: platforms
module: platforms/rancher/install
---

# Rancher

This section of documentation covers use of StorageOS in
[Rancher](https://www.rancher.com/). StorageOS can be deployed in any Rancher cluster
that meets the [StorageOS prerequisites]({%link
_docs/prerequisites/overview.md %}).

StorageOS transparently supports Rancher deployments using CentOS, RHEL, Debian
or RancherOS (CSI is not supported on RancherOS) and can support other
Linux distributions detailed in the [systems supported page]({%link
_docs/prerequisites/systemconfiguration.md %}) if the appropriate kernel
modules are present.

StorageOS integrates transparently with Kubernetes. The user can provide
standard PVC definitions and StorageOS will dynamically provision them.
StorageOS presents volumes to containers with standard POSIX mount targets.
This enables the Kubelet to mount StorageOS volumes using standard linux device
files. Checkout [device presentation]({%link
_docs/prerequisites/systemconfiguration.md %}) for more details.

---
layout: guide
title: StorageOS Docs - Kubernetes
anchor: platforms
module: platforms/kubernetes
---

# Kubernetes

This section of documentation covers use of the vanilla [Kubernetes](https://kubernetes.io/)
orchestrator. The StorageOS installation procedure is slightly different depending on the version
you have deployed, so follow the appropriate guide. Other documents in this section are version
agnostic.

We support Kubernetes versions 1.7 and upwards.

StorageOS integrates transparently with Kubernetes. The user can provide standard PVC definitions
and StorageOS will dynamically provision them. StorageOS presents volumes to containers with
standard POSIX mount targets. This enables the Kubelet to mount StorageOS volumes using standard
linux device files. Checkout [device presentation]({%link _docs/prerequisites/systemconfiguration.md
%}) for more details.

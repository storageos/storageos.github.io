---
layout: guide
title: StorageOS Docs - Namespaces
anchor: concepts
module: concepts/namespaces
---

# Namespaces

StorageOS namespaces are an identical concept to Kubernetes namespaces. They
are intended to allow a StorageOS cluster to be used by multiple teams across
multiple projects.

It is not necessary to create StorageOS namespaces manually, as StorageOS maps
Kubernetes namespaces 1:1 when PersistentVolumeClaims using the StorageOS
StorageClass are created.

Access to Namespaces is controlled through user or group level [policies]({%link
_docs/concepts/policies.md %})

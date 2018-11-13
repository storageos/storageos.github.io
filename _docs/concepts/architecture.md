---
layout: guide
title: StorageOS Docs - Architecture
anchor: concepts
module: concepts/architecture
---

# Architecture

StorageOS is a software-defined storage platform for running stateful
applications in containers.

Read about [the cloud native storage principles behind
StorageOS](https://storageos.com/storageos-cloud-native-storage).

Fundamentally, StorageOS aggregates storage attached to nodes in a cluster,
creates a virtual pool across nodes, and presents virtual volumes from the pool
into containers.

It is agnostic to the underlying storage and runs equally on
bare metal, in virtual machines or on cloud providers.

![StorageOS architecture](/images/docs/concepts/architecture.png)

StorageOS is deployed as one container on each node that presents or consumes
storage, available as `storageos/node` on the Docker Hub. In Kubernetes,
this is typically managed as a daemonset, next
to the applications. StorageOS runs entirely in user space.

StorageOS is designed to feel familiar to Kubernetes and Docker users. Storage
is managed through standard StorageClasses and PersistentVolumeClaims, and
features are controlled by Kubernetes-style labels and selectors, prefixed with
`storageos.com/`.

## Storage volumes

StorageOS uses the storage capacity from the nodes where it is installed to
provide thinly-provisioned volumes. That space is selected from the mount point
of `/var/lib/storageos/data` on the host. It is recommended that disk devices
are used exclusively for StorageOS, as described in [Setup storage in host
]({%link _docs/operations/managing-host-storage.md %})

Any container may mount a StorageOS virtual volume from any node, regardless of
whether the container and volume are colocated on the same node or the volume is
remote. Therefore, applications may be started or restarted on any node and
access volumes transparently.

Volumes are provisioned from a storage pool and are thinly provisioned.

By default, volumes are cached to improve read performance and compressed to
reduce network traffic.

| Available memory   | % of overall memory reserved by StorageOS for caching |
|:-------------------|:---------------------|
| 3 GB or less       | 3%                   |
| 3-8 GB             | 5%                   |
| 8-12 GB            | 7%                   |
| 12 GB or more      | 10%                  |



<!-- Add info on volume auto-follow -->

---
layout: guide
title: StorageOS Docs - Volumes
anchor: concepts
module: concepts/volumes
---

# Volumes

StorageOS volumes are a logical construct which represent a writeable volume
and exhibit standard POSIX semantics. We present volumes as mounts into
containers via the StorageOS FUSE layer.

Conceptually, StorageOS volumes have a front end presentation, which is the
side the application sees, and a backend presentation, which is the actual
on-disk format. Depending on the configuration, frontend and backend components
may be on the same or different hosts.

Volumes are formatted using the linux standard ext4 filesystem as standard.
Different filesystems may be supported in the future.

# On Disk Format

StorageOS represents files on disk as... (fill in with Alex)

# Maximum Volume Size

Because volumes need to fit on a single node, the maximum volume size a cluster
can support depends on the available space on individual nodes.

# Metrics

We present various metrics regarding StorageOS volumes, including used capacity
and throughput, via our [Prometheus Endpoint]({% link
_docs/reference/prometheus.md %}).



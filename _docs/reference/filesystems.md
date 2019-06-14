---
layout: guide
title: StorageOS Supported File systems
anchor: reference
module: reference/filesystems
---

# Supported Filesystems

## Host Filesystems

StorageOS will automatically use `/var/lib/storageos` on each host as a base
directory for storing [configuration and blob
files](/docs/concepts/volumes#blob-files). Recommended host filesystem types
are `ext4` or `xfs`. If you require a specific filesystem please [contact
StorageOS](/docs/support/contactus).

## Persistent Volume Filesystems

StorageOS provides a block device on which a file system can be created. The
creation of the filesystem is either handled by StorageOS or by Kubernetes
which affects what filesystems can be created.

### Native Driver

When using StorageOS with the native driver, Kubernetes is responsible for running mkfs
against the StorageOS block device. This means that any file system that Kubernetes can create
can be used.

However if the StorageOS CLI is used to mount a device then an ext4 filesystem
will be created by default.

### CSI Driver

When using StorageOS with the CSI driver, StorageOS is responsible for running
mkfs against the block device that pods mount. StorageOS is able to create
ext2, ext3, ext4 and xfs file systems.

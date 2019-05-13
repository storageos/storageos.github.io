---
layout: guide
title: StorageOS Supported File systems
anchor: reference
module: reference/filesystems
---

# Supported Filesystems

StorageOS provides a block device on which a file system can be created.
However who creates this file system affects what filesystems StorageOS can
support.

## Native Driver

When using StorageOS with the native driver, Kubernetes is responsible for running mkfs
against the StorageOS block device. This means that any file system that Kubernetes can create
can be used.

However if the StorageOS CLI is used to mount a device then an ext4 filesystem
will be created by default.

## CSI Driver

When using StorageOS with the CSI driver, StorageOS is responsible for running
mkfs against the block device that pods mount. StorageOS is able to create
ext2, ext3, ext4, btrfs and xfs file systems.

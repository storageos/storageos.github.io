---
layout: guide
title: StorageOS Docs - Device Presentation
anchor: install
module: install/prerequisites/devicepresentaion.md
---

# Device presentation

StorageOS is developed using Linux-IO (LIO) Target. An open-source implementation of the SCSI target. In addition, StorageOS uses FUSE, known as a Filesystem in Userspace. It is a 
software interface for Unix-like computer operating systems that lets non-privileged users create their own file systems without editing kernel code.

However, LIO is supported by most of the kernels available nowadays, some distributions have left the kernel module out of the main kernel image.

Check the [os distribution support page](/docs/reference/os_support) to validate what OS can be used and how to enable LIO.

## Network Block Device

StorageOS versions prior 0.11.0 used NBD (Network Block Device) to present virtual block devices from userspace. **NBD is no longer used or required by StorageOS.**

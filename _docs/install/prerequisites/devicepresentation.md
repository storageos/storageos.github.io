---
layout: guide
title: StorageOS Docs - Device Presentation
anchor: install
module: install/prerequisites/devicepresentaion.md
---

# Device presentation

StorageOS is developed using Linux-IO (LIO) Target. An open-source implementation of the SCSI target. StorageOS uses a 
software interface for Unix-like computer operating systems that lets non-privileged users create their own file systems without editing kernel code.

However, LIO is supported by most of the kernels available nowadays, some distributions have left the kernel module out of the main kernel image. For those, distributions with support,
will be required to enable kernel modules. 

Check the [os distribution support page](/docs/reference/os_support) to validate what OS can be used and how to enable LIO.

## Network Block Device

StorageOS versions prior 1.0.0 used to use NBD (Network Block Device) to present virtual block devices from userspace. **NBD is no longer used or required by StorageOS.**

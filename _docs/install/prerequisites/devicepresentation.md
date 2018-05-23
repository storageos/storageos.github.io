---
layout: guide
title: StorageOS Docs - Device Presentation
anchor: install
module: install/prerequisites/devicepresentaion.md
---

# Device presentation

StorageOS requires the Linux-IO (LIO) Target, an open-source implementation of the SCSI target.


Although, LIO is supported by most of the kernels available nowadays, some distributions have left the kernel module out of the main kernel image.
For supported distributions it is mandatory to enable certain kernel modules. 

Check the [OS distribution support page](/docs/reference/os_support) to validate which OS can be used and how to enable LIO.

## Network Block Device (deprecated)

StorageOS versions prior to 1.0.0 used to use NBD (Network Block Device) to present virtual block devices from userspace. **NBD is no longer used or required by StorageOS.**

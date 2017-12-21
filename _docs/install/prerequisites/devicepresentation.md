---
layout: guide
title: StorageOS Docs - Device Presentation
anchor: install
module: install/prerequisites/devicepresentaion.md
---

# Device presentation

StorageOS requires one of two runtime requirements to present virtual block devices
from userspace. While not mandatory, the NBD aproach does offer significantly
better performance over the loop-device alternative.

## Network Block Device

NBD (Network Block Device) is a Linux kernel module, available on many
distributions, that allows block devices to be run in userspace. It is not a
requirement for StorageOS to run, but improves performance significantly and
will be used in preference if available. To enable the module and increase the
number of allowable devices, run:

```bash
sudo modprobe nbd nbds_max=1024
```

To ensure the NBD module is loaded on reboot:

1. Add the following line to `/etc/modules`

    ```text
    nbd
    ```

1. Add the following module configuration lines in `/etc/modprobe.d/nbd.conf`

    ```text
    options nbd nbds_max=1024
    options nbd max_part=15
    ```

Your distribution may set different defaults for the provided
parameters. For StorageOS to run correctly, our values must be used in their
place.

## Loopback driver (fallback)

The loopback driver is a Linux kernel feature, which allows creation of a block
device whose files map to the bocks of a regular file. This kernel feature is a
runtime requirement in the absence of the NBD kernel module.

While this feature is enabled by default on most systems, StorageOS does require some
specific parameters to be set. To configure these, add the following
configuration line in `/etc/modprobe.d/loop.conf`

```text
options loop max_loop=1024
```

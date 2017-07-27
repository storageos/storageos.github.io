---
layout: guide
title: StorageOS Docs - Network Block Device
anchor: install
module: install/prerequisites/nbd
---

# Network Block Device

NBD (Network Block Device) is a default Linux kernel module that allows block
devices to be run in userspace. It is not a requirement for StorageOS to run,
but improves performance significantly. To enable the module and increase the
number of allowable devices, run:

```bash
sudo modprobe nbd nbds_max=1024
```

To ensure the NBD module is loaded on reboot:

1. Add the following line to `/etc/modules`

    ```text
    nbd
    ```

1. Add the following module configuration line in `/etc/modprobe.d/nbd.conf`

    ```text
    options nbd nbds_max=1024
    ```

---
layout: guide
title: StorageOS Docs - Troubleshooting installation
anchor: install
module: install/docker/troubleshooting
---

# Common Docker installation problems and solutions

## Network Block Device (NBD)

The default on most linux distributions is to support 16 devices. Setting the
nbds_max parameter allows for more than 16.

By default 16 minor number devices are initialised per major node for handling
partitions. The number of partitions can be controlled by the max_part
parameter. Changing the default will break StorageOS, so either do not specify
the parameter, or if it is specified, the only valid values are 0 and 15.

If the wrong number of devices have been initialised it is possible to rmmod nbd
and then re-run modprobe. it is only possible to run rmmod if none of the
devices are in use.

---
layout: guide
title: Creating the Boot Partition
anchor: install
module: install/vagrant
---

# Creating a Boot Partition

Create a virtual machine with the following settings (be sure to a add smaller disk for the boot partition first so it is used for the StorageOS ISO image Installation.

![image](/images/docs/isoinstall/CreateBootPart.png)

You may want to configure this hard disk as thin-provisioned in ESX to conserve space. This volume can be any size you want (10GB for StorageOS--to be reduce for the GA release--plus capacity for the Docker volumes).

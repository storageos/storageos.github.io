---
layout: guide
title: StorageOS Docs - Storage configuration
anchor: operations
module: operations/storage-host-config
---

# Storage host configuration

StorageOS saves data on hosts where StorageOS is running. The StorageOS directory
is `/var/lib/storageos`. Both raw data and metadata are stored here.

It is recommended to isolate the `/var/lib/storageos` directory from the root
filesystem. Default installations of StorageOS will use `/` as a data store. In
the event that the `/` partition is filled, the host OS can malfunction.
Therefore, it is best to mount a different device or partition for the
StorageOS directory. StorageOS is agnostic to the type of filesystem mounted in
`/var/lib/storageos`.

In addition, StorageOS can extend the storage available to StorageOS volumes.
It is possible to use different disks or partitions to expand StorageOS’
available space. By default, the directory `/var/lib/storageos/data/dev1` will be
created when volumes are used. However, it is possible to shard the data files
by creating more directories alike. StorageOS will save data in any directory
that follows the regex `dev[0-9]+`, such as `/var/lib/storageos/data/dev2` or
`/var/lib/storageos/data/dev5`. This functionality enables operators to mount
different devices into `devX` directories and StorageOS will recognise them as
available storage automatically. For more information about how to extend
available storage and different options available, check the [Extend Storage
Capacity]({%link _docs/operations/extend-storage.md %}) page. 

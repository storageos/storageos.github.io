---
layout: guide
title: StorageOS Docs - Extend available storage
anchor: operations
module: operations/extend-storage
---

# Extend available storage

StorageOS uses the storage available in the nodes where it is installed to present as available for
volumes. That space is selected from the mount point of `/var/lib/storageos/data` on the host. It is
recommended to use specific disk devices only for StorageOS.

StorageOS needs a filesystem formatted and mounted to `/var/lib/storageos/data`. It is possible to
use different disks or partitions to expand StorageOS' available space. By default, the directory
`/var/lib/storageos/data/dev1` will be created when volumes are used. However, it is possible to
shard the data files by creating more directories alike. StorageOS will save data in any directory
that follows the name `dev[0-9]+`, such as `/var/lib/storageos/data/dev2` or
`/var/lib/storageos/data/dev5`. This functionality enables operators to mount different devices into
devX directories and StorageOS will recognise them as available storage automatically.

These are 2 possible options to expand the available disk space for StorageOS to allocate (combinations of
these options are also possible):

1. Mount filesystem in `/var/lib/storageos/data/devX` (available on next release)
1. Use LVM to expand the logical volume available to StorageOS

## Option 1: Mount filesystem (available on next release)

This option enables operators to expand the cluster's available space at any time without having to stop any service or forcing operational downtime.
The expansion of disk is transparent for applications or StorageOS Volumes. StorageOS will use the new
available space to create new data files in case that the node run out of disk space. By expanding
the number of disks that serve data, the throughput also increases as the data of one StorageOS
volume can be segmented in different physical devices.

1. Context

   We assume that there is a disk available in our Linux system without formatting in additin to the root
   filesystem. StorageOS data dir dev1 (`/var/lib/storageos/data/dev1`) is using `/dev/xvda1`. We will
   use the device `/dev/xvdf` to expand StorageOS available space.

   List available block devices in the host.

   ```
   root@ip-172-20-58-239:~# lsblk
   NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
   xvda    202:0    0  128G  0 disk
   `-xvda1 202:1    0  128G  0 part /
   xvdf    202:80   0  100G  0 disk
   ```

   Check StorageOS cluster's available capacity.

   ```
   root@ip-172-20-58-239:~# storageos node ls --format="table {{ "{{.Name"}}}}\t{{ "{{.Capacity"}}}}"
   NAME                                          TOTAL
   ip-172-20-119-113.eu-west-1.compute.internal  128.7GB
   ip-172-20-58-239.eu-west-1.compute.internal   128.7GB
   ip-172-20-68-139.eu-west-1.compute.internal   128.7GB
   ip-172-20-84-11.eu-west-1.compute.internal    128.7GB
   ```

1. Format device

   ```
   root@ip-172-20-58-239:/var/lib/storageos/data# mkfs -t ext4 /dev/xvdf
   mke2fs 1.42.12 (29-Aug-2014)
   Creating filesystem with 26214400 4k blocks and 6553600 inodes
   Filesystem UUID: 380712fa-6f82-477a-81a5-d7466d4c6b7f
   Superblock backups stored on blocks:
           32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
           4096000, 7962624, 11239424, 20480000, 23887872

   Allocating group tables: done
   Writing inode tables: done
   Creating journal (32768 blocks): done
   Writing superblocks and filesystem accounting information: done
   ```

1. Mount filesystem

   ```
   root@ip-172-20-58-239:~# mkdir -p /var/lib/storageos/data/dev2
   root@ip-172-20-58-239:~# mount /dev/xvdf /var/lib/storageos/data/dev2
   ```

1. Verify available storage

   In less than 30 seconds, StorageOS will see the new available capacity.

   ```
   root@ip-172-20-58-239:~# storageos node ls --format="table {{ "{{.Name"}}}}\t{{ "{{.Capacity"}}}}"
   NAME                                          TOTAL
   ip-172-20-119-113.eu-west-1.compute.internal  128.7GB
   ip-172-20-58-239.eu-west-1.compute.internal   227.3GB
   ip-172-20-68-139.eu-west-1.compute.internal   128.7GB
   ip-172-20-84-11.eu-west-1.compute.internal    128.7GB

   root@ip-172-20-58-239:/var/lib/storageos/data/dev2# lsblk
   NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
   xvda    202:0    0  128G  0 disk
   `-xvda1 202:1    0  128G  0 part /
   xvdf    202:80   0  100G  0 disk /var/lib/storageos/data/dev2
   ```

   Note that the node ip-172-20-58-239.eu-west-1.compute.internal has increased the TOTAL capacity in
   100Gi.

> Persist the mount at boot by adding the mount endpoint to `/etc/fstab`

## Option 2: Expand LVM logical volume

This option enables operators to take advantage of LVM features to manage disks. Even though, it is recommended to
prepare the block devices and disks before deploying StorageOS in that node for better maintainability, it is possible to use Option 1 to mount LVM logical volumes into `devX` directories for ongoing installations.
The best approach would be to create a LVM logical volume and mount it to `/var/lib/storageos` so it
can be expanded in case that more capacity is needed. Performance throughput also increases by
parallelising input/output operations.

1. Context

   We assume that `/var/lib/storageos/data/` is mounted from a LVM logical volume before StorageOS initialise in that node. We are using a volumegroup named `storageos` and logical volume called `data`. There is a second physical disk `/dev/xvdg` unused.


    List available block devices in the host.
    ```bash
    root@ip-172-20-84-11:~# lsblk
    NAME             MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    xvda             202:0    0  128G  0 disk
    `-xvda1          202:1    0  128G  0 part /
    xvdf             202:80   0  100G  0 disk
    `-storageos-data 254:0    0   99G  0 lvm  /var/lib/storageos/data
    xvdg             202:96   0  100G  0 disk
    ```

    Check StorageOS cluster's available capacity.
    ```bash
    root@ip-172-20-84-11:~# storageos node ls --format="table {{ "{{.Name"}}}}\t{{ "{{.Capacity"}}}}"
    NAME                                          TOTAL
    ip-172-20-119-113.eu-west-1.compute.internal  128.7GB
    ip-172-20-58-239.eu-west-1.compute.internal   128.7GB
    ip-172-20-68-139.eu-west-1.compute.internal   128.7GB
    ip-172-20-84-11.eu-west-1.compute.internal    100.3GB # --> LVM storageos/data volume
    ```

1. Add physical disk to LVM

   ```bash
   root@ip-172-20-84-11:~# vgextend storageos /dev/xvdg
     Volume group "storageos" successfully extended
   ```

   The volume group `storageos` must have 2 physical volumes (#PV)

   ```bash
   root@ip-172-20-84-11:~# vgs
     VG        #PV #LV #SN Attr   VSize   VFree
     storageos   2   1   0 wz--n- 199.99g 104.99g
   ```

1. Extend logical volume `data`

   ```bash
   root@ip-172-20-84-11:~# lvextend -L+100G /dev/storageos/data
     Size of logical volume storageos/data changed from 95.00 GiB (24320 extents) to 195.00 GiB (49920 extents).
     Logical volume data successfully resized
   ```

1. Resize the FileSystem

   > Your filesystem must support the option to be expanded, and to do so while in use. Otherwise, you need to unmount first.

   ```bash
   root@ip-172-20-84-11:~# resize2fs /dev/storageos/data
   resize2fs 1.42.12 (29-Aug-2014)
   Filesystem at /dev/storageos/data is mounted on /var/lib/storageos/data; on-line resizing required
   old_desc_blocks = 6, new_desc_blocks = 13
   The filesystem on /dev/storageos/data is now 51118080 (4k) blocks long.
   ```

1. Check new available space

   The mounted file system to `/var/lib/storageos/data` has increased its size.

   ```bash
   root@ip-172-20-84-11:~# df -h /dev/mapper/storageos-data
   Filesystem                  Size  Used Avail Use% Mounted on
   /dev/mapper/storageos-data  192G   60M  183G   1% /var/lib/storageos/data
   ```

   StorageOS available storage has increased too.

   ```bash
   root@ip-172-20-84-11:~# storageos node ls --format="table {{ "{{.Name"}}}}\t{{ "{{.Capacity"}}}}"
   NAME                                          TOTAL
   ip-172-20-119-113.eu-west-1.compute.internal  128.7GB
   ip-172-20-58-239.eu-west-1.compute.internal   128.7GB
   ip-172-20-68-139.eu-west-1.compute.internal   128.7GB
   ip-172-20-84-11.eu-west-1.compute.internal    201GB # --> 100G more available
   ```

> Persist the mount at boot by adding the mount point to `/etc/fstab`

---
layout: guide
title: StorageOS Docs - Volumes
anchor: manage
module: manage/volumes
# Last reviewed by cheryl.hung@storageos.com on 2017-04-13
---

# Volumes

Volumes are used to store data.

## Create a volume

To create a 15GB volume in `default` namespace, run:
```bash
$ storageos volume create --namespace default --size 15 volume-name
default/volume-name
```

## List all volumes

To view all volumes in all namespaces, run:

```bash
storageos volume ls
NAMESPACE/NAME        SIZE                MOUNTED BY          MOUNTPOINT          STATUS              REPLICAS
default/volume-name   15GB                                                        active              0/0
```

Create a new volume in a new namespace.
```bash
$ storageos volume create myvolume --namespace legal
legal/myvolume
```

Create a 10GB scratch volume from an existing pool called `no-ha`, and install the XFS file system. Valid types for `--fstype` are `ext2`, `ext3`, `ext4`, `xfs` and `btrfs`.
```bash
$ storageos volume create --pool no-ha --size 10 --fstyle xfs --namespace legal scratch1
legal/scratch1
```

Check if a volume is mounted.
```bash
$ storageos volume inspect legal/myvolume | grep mounted
        "mounted": false,
```

## Inspecting volume details

To view volume details, such as where it's deployed and health, use `inspect` command and specify `namespace/volume-name`.
```bash
$ storageos volume inspect legal/scratch1
[
    {
        "id": "770620f3-7a93-4b90-8349-4b0d2ae88129",
        "inode": 0,
        "name": "scratch1",
        "size": 10,
        "pool": "no-ha",
        "fsType": "xfs",
        "description": "",
        "labels": {
            "storageos.driver": "filesystem"
        },
        "namespace": "legal",
        "master": {
            "id": "",
            "inode": 0,
            "controller": "",
            "health": "",
            "status": "",
            "createdAt": "0001-01-01T00:00:00Z"
        },
        "mounted": false,
        "replicas": null,
        "health": "",
        "status": "failed",
        "statusMessage": "",
        "createdAt": "0001-01-01T00:00:00Z",
        "createdBy": ""
    }
]
```

## Removing volumes

To delete a volume, use `rm` command (all data in this volume will be lost):
```bash
$ storageos volume rm default/volume-name
default/volume-name
```

This command will fail if the volume is mounted. To delete a mounted volume, add `--force` flag:
```bash
$ storageos volume rm --force default/volume-name
default/volume-name
```

Volumes might not immediately disappeared as data from the disks have to be purged.

## Further reading

* [Using labels with volumes](labels.html)

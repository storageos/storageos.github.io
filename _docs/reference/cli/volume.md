---
layout: guide
title: StorageOS Docs - Volumes
anchor: reference
module: reference/cli/volume
# Last reviewed by cheryl.hung@storageos.com on 2017-04-13
---

# Volumes

```bash
$ storageos volume

Usage:	storageos volume COMMAND

Manage volumes

Options:
      --help   Print usage

Commands:
  create      Create a volume
  inspect     Display detailed information on one or more volumes
  ls          List volumes
  mount       Mount specified volume
  rm          Remove one or more volumes
  unmount     Unmount specified volume
  update      Update a volume

Run 'storageos volume COMMAND --help' for more information on a command.
```

### `storageos volume create`

To create a 15GB volume in the default namespace:

```bash
$ storageos volume create --namespace default --size 15 --fstype xfs volume-name
default/volume-name
```

### `storageos volume inspect`

To view volume details:

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


### `storageos volume ls`

To view all volumes in all namespaces:

```bash
$ storageos volume ls
NAMESPACE/NAME        SIZE                MOUNTED BY          MOUNTPOINT          STATUS              REPLICAS
default/volume-name   15GB                                                        active              0/0
```

### `storageos volume mount`

To mount a volume on the current node into `/mnt` (note this requires root):

```bash
sudo storageos volume mount default/volume-name /mnt
```

### `storageos volume rm`

To delete a volume (use ``--force` to delete mounted volumes):

```bash
$ storageos volume rm default/volume-name
default/volume-name
```

### `storageos volume unmount`

To unmount a volume on the current node (note this requires root):

```bash
sudo storageos volume unmount default/volume-name
```

>**Unmounting volumes requires the user to be root.**

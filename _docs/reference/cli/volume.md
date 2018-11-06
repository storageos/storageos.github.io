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

Usage:  storageos volume COMMAND

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

Note that the mount and unmount commands are not available on MacOS or Windows.

### `storageos volume create`

To create a 15GB volume in the default namespace:

```bash
$ storageos volume create --namespace default --size 15 --fstype xfs volume-name
default/volume-name
```

### `storageos volume inspect`

To view volume details:

```bash
$ storageos volume inspect default/volume-name
[
    {
        "id": "8d17066e-07d9-3f5f-e0de-edfc28e13f8f",
        "inode": 0,
        "name": "volume-name",
        "size": 15,
        "pool": "default",
        "fsType": "xfs",
        "description": "",
        "labels": {},
        "namespace": "default",
        "nodeSelector": "",
        "master": {
            "id": "",
            "inode": 0,
            "node": "",
            "nodeName": "storageos-1",
            "controller": "",
            "controllerName": "",
            "health": "healthy",
            "status": "active",
            "createdAt": "0001-01-01T00:00:00Z"
        },
        "mounted": false,
        "mountDevice": "",
        "mountpoint": "",
        "mountedAt": "0001-01-01T00:00:00Z",
        "replicas": [],
        "health": "",
        "status": "active",
        "statusMessage": "",
        "mkfsDone": false,
        "mkfsDoneAt": "0001-01-01T00:00:00Z",
        "createdAt": "0001-01-01T00:00:00Z",
        "createdBy": "storageos"
    }
]
```

### `storageos volume ls`

To view all volumes in all namespaces:

```bash
$ storageos volume ls
NAMESPACE/NAME       SIZE  MOUNT  SELECTOR  STATUS  REPLICAS  LOCATION
default/volume-name  15GB                   active  0/0       storageos-1 (healthy)
```

### `storageos volume mount`

To mount a volume on the current node into `/mnt` (note this requires root):

```bash
sudo -E storageos volume mount default/volume-name /mnt
```

_(Important: use the `sudo -E` option to preserve the storageos environment credentials)_

### `storageos volume rm`

To delete a volume (use `--force` to delete mounted volumes):

```bash
$ storageos volume rm default/volume-name
default/volume-name
```

### `storageos volume unmount`

To unmount a volume on the current node (note this requires root):

```bash
sudo -E storageos volume unmount default/volume-name
```

_(Important: use the `sudo -E` option to preserve the storageos environment credentials)_

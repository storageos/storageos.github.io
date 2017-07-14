---
layout: guide
title: StorageOS Docs - Creating volumes
anchor: manage
module: manage/volumes/create
# Last reviewed by cheryl.hung@storageos.com on 2017-04-13
---

# Creating volumes

## Create a volume

Volumes can be created using the StorageOS CLI or API, the Docker CLI, or
dynamically.

Volume names must consist of lower case alphanumeric characters or '-', and must
start and end with an alphanumeric character. By default, volumes are 5GB in
size (overridden by `--size`) and formatted as ext4 (overridden by
`--fstype=ext2|ext3|ext4|xfs|btrfs`). Additional behaviours may be specified by
adding labels. See [Using labels with volumes]({% link _docs/manage/volumes/labels.md %}).

To create a 15GB volume in the `default` namespace, run:

### StorageOS CLI

```bash
$ storageos volume create --namespace default --size 15 --fstype ext4 volume-name
default/volume-name
```

### Docker CLI

Volumes used by Docker *must* be in the `default` namespace.

```bash
$ docker volume create --driver storageos --opt size=15 --opt fstype=ext4 volume-name
volume-name
```

### Docker Dynamic Provisioning

```bash
docker run --volume-driver storageos -v volume-name:/data alpine ash -i
```

When dynamic provisioning is used it is not possible to specify options at
creation time. Size will default to 5GB, but can be dynamically expanded using
the CLI or API.

## List all volumes

To view all volumes in all namespaces, run:

### StorageOS CLI

```bash
$ storageos volume ls
NAMESPACE/NAME        SIZE                MOUNTED BY          MOUNTPOINT          STATUS              REPLICAS
default/volume-name   15GB                                                        active              0/0
```

### Docker CLI

```bash
docker volume ls
```

## Mounting volumes

To mount a volume on the current node (into `/mnt`), run:

```bash
storageos volume mount default/volume-name /mnt
```

In order for the mount to succeed, StorageOS must be running on the node and the
volume must not be mounted anywhere else. When the volume is mounted a lock is
placed on the volume to ensure it is not written by multiple concurrent writers
as this could lead to data inconsistency.

If the volume has not yet been formatted, the filesystem type set at creation
time or via update will be used. `ext4` will be used by default.

## Unmounting volumes

To unmount a volume on the current node, run:

```bash
storageos volume unmount default/volume-name
```

The unmount command should be run on the node that has the volume mounted.
Unmounting the volume detaches the filesystem from the node and removes the
mount lock. In cases where the filesystem was unmounted manually using the Linux
`umount` utility, or the node is no longer active, you can specify the `--force`
flag to only remove the mount lock.

## Inspecting volume details

To view volume details, such as where it's deployed and health, use `inspect`
command and specify `namespace/volume-name`.

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

This command will fail if the volume is mounted. To delete a mounted volume, add
`--force` flag:

```bash
$ storageos volume rm --force default/volume-name
default/volume-name
```

Volumes might not be removed immediately as data will be purged in the
background.

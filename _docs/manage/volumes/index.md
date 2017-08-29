---
layout: guide
title: StorageOS Docs - Volumes
anchor: manage
module: manage/volumes/index
# Last reviewed by cheryl.hung@storageos.com on 2017-04-13
---

# Volumes

Volumes are used to store data.

Volumes are provisioned from [storage pools]({% link
_docs/manage/volumes/pools.md %}) and sit in a [namespace]({% link
_docs/manage/volumes/namespaces.md %}). All volumes are thinly provisioned so
only consume capacity which is actually used.

Volume names consist of lower case alphanumeric characters or '-', and must
start and end with an alphanumeric character. By default, volumes are 5GB in
size (overridden by `--size`) and formatted as ext4 (overridden by
`--fstype=ext2|ext3|ext4|xfs|btrfs`).

In order to mount volumes into containers, they are formatted with a filesystem
such as `ext4`. All volumes are accessible to any container anywhere on the cluster
(global namespace) but each volume may only be mounted by one container at a
time. Additional behaviours may be specified by adding [labels]({% link _docs/manage/volumes/labels.md %}).

Volumes can be created and managed using the [standard Docker
CLI](https://docs.docker.com/engine/reference/commandline/volume_create/) or
through the [StorageOS CLI]({% link _docs/reference/cli/volume.md %}) for more
options and control.

## Using the Docker CLI

>**The Docker CLI does not support namespaced volumes** so all volumes created using
the Docker CLI must be in the `default` namepsace.

To create a 15GB volume, run:
```bash
$ docker volume create --driver storageos --opt size=15 --opt fstype=ext4 volume-name
```

To create a volume and provision to a Docker container in one step, run:
```bash
docker run --volume-driver storageos -v volume-name:/data alpine ash -i
```

When using dynamic provisioning it is not possible to specify options at
creation time. The volume will default to 5GB, but the size can be dynamically
expanded using the CLI or API.

To list all volume, run:
```bash
docker volume ls
```

## Using the StorageOS CLI

With the StorageOS CLI, you must specify a namespace using the `--namespace` flag.

To create a 15GB volume in the `default` namespace, run:

```bash
$ storageos volume create --namespace default --size 15 --fstype ext4 volume-name
default/volume-name
```

To view all volumes in all namespaces, run:

```bash
$ storageos volume ls
NAMESPACE/NAME        SIZE                MOUNTED BY          MOUNTPOINT          STATUS              REPLICAS
default/volume-name   15GB                                                        active              0/0
```

To mount a volume on the current node into `/mnt`, run:

```bash
storageos volume mount default/volume-name /mnt
```

In order for the mount to succeed, StorageOS must be running on the node and the
volume must not be mounted anywhere else. When the volume is mounted a lock is
placed on the volume to ensure it is not written by multiple concurrent writers
as this could lead to data inconsistency.

By default the volume will be formatted using `ext4`, which may be overridden or
updated with `--fstype`.

## Resizing volumes

To resize a volume, use `storageos volume update --size <new_size_in_GB> `.

The volume is expanded immediately but you will need to manually resize the
filesystem by calling `resize2fs`.

Shrinking a volume is not supported.

## Unmounting and removing volumes

To unmount a volume on the current node, run:

```bash
storageos volume unmount default/volume-name
```

The unmount command should be run on the node that has the volume mounted.
Unmounting the volume detaches the filesystem from the node and removes the
mount lock. In cases where the filesystem was unmounted manually using the Linux
`umount` utility, or the node is no longer active, you can specify the `--force`
flag to only remove the mount lock.

To delete a volume, run:

```bash
$ storageos volume rm default/volume-name
default/volume-name
```

All data in this volume will be lost.

This command will fail if the volume is mounted. To delete a mounted volume, add
`--force` flag:

```bash
$ storageos volume rm --force default/volume-name
default/volume-name
```

Volumes may not be removed immediately as the data will be purged in the
background.

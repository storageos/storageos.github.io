---
layout: guide
title: StorageOS Docs - Volumes
anchor: manage
module: manage/volumes
---

# Volumes

Volumes are used to store data.

## Create a volume

To create a 15GB volume in `default` namespace, run:

    storageos volume create --namespace default --size 15 volume-name

## List all volumes

To view all volumes in all namespaces, run:

    storageos volume ls

Create a new volume in a new namespace.
```
$ storageos volume create myvolume -n legal
legal/myvolume
```

Create a 10GB scratch volume from an existing pool called `no-ha`

```
$ storageos volume create scratch1 -p no-ha -s 10 -f xfs -n legal
legal/scratch1
```

Check if a volume is mounted.

```
storageos volume inspect legal/myvolume | grep mounted
        "mounted": false,
```

## Inspecting volume details

To view volume details, such as where it's deployed, labels and health, use `inspect` command and specify both namespace `default` and volume name `volume-name` separated by `/`:
<!-- TODO(CH) add labels -->
```
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

    storageos volume rm default/volume-name

This command will fail if the volume is mounted, to delete mounted volume, add `--force` flag:

    storageos volume rm --force default/volume-name

Volumes might not immediately disappeared as data from the disks have to be purged.

---
layout: guide
title: Using labels
anchor: manage
module: manage/labels
---

# Labels

Labels are a mechanism for applying metadata to StorageOS objects. You can use them to annotate or organise your volumes in any way that makes sense for your organization or app.

A label is a key-value pair that is stored as a string. An object may have multiple labels but each key-value pair must be unique within an object.

You should prefix labels with your organization domain, such as `example.your-label`. Labels prefixed with `storageos.*` are reserved for internal use.

Applying special labels triggers features on volumes:

* `storageos.driver=filesystem` - defaults to `filesystem` driver.
* `storageos.feature.replicas=2` - number of desired replicas (0-5).
* `storageos.feature.compression=true` - network compression, depending on data type might greatly increase throughput.
* `storageos.feature.throttle=true` - reduce volume's performance.
* `storageos.feature.cache=true` - enable caching for volume.

To check the labels on a volume:

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

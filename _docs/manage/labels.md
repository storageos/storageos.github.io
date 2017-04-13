---
layout: guide
title: StorageOS Docs - Labels
anchor: manage
module: manage/labels
---

# Labels

Labels are a mechanism for applying metadata to StorageOS objects. You can use
them to annotate or organise your volumes in any way that makes sense for your
organization or app.

A label is a key-value pair that is stored as a string. An object may have
multiple labels but each key-value pair must be unique within an object.

You should prefix labels with your organization domain, such as
`example.your-label`. Labels prefixed with `storageos.*` are reserved for
internal use.

To create a volume with labels:
```bash
$ storageos volume create --namespace default --label env=prod volume-name
default/volume-name
```

To check the labels on a volume:
```bash
$ storageos volume inspect default/volume-name
[
    {
        "id": "4f1dc138-7e31-2914-7531-545b66b2af18",
        "inode": 83150,
        "name": "volume-name",
        "size": 5,
        "pool": "default",
        "fsType": "",
        "description": "",
        "labels": {
            "env": "prod",
            "storageos.driver": "filesystem"
        },
        "namespace": "default",
        "master": {
            "id": "c2589048-a3d5-e2bb-1bf4-ca35a0cf9936",
            "inode": 258720,
            "controller": "f23334c1-f886-d403-2a4c-98b81bf2cd92",
            "health": "healthy",
            "status": "active",
            "createdAt": "2017-04-13T16:44:41.349142801Z"
        },
        "mounted": false,
        "mountpoint": "",
        "mountedAt": "0001-01-01T00:00:00Z",
        "replicas": [],
        "health": "",
        "status": "active",
        "statusMessage": "",
        "createdAt": "2017-04-13T16:44:41.217209996Z",
        "createdBy": "storageos"
    }
]
```

# StorageOS feature labels

Applying specific labels triggers compression, replication and other storage
features on volumes. The following feature labels are supported:


| Label                                | Feature     | Behaviour                                                |
|:-------------------------------------|:------------|:---------------------------------------------------------|
| `storageos.feature.replicas=2`       | Replication | Number of desired replicas between 0-5.                  |
| `storageos.feature.compression=true` | Compression | Depending on data type might greatly increase throughput.|
| `storageos.feature.throttle=true`    | Throttle    | Reduce volume's performance.                             |
| `storageos.feature.cache=true`       | Caching     | Enable caching for volume.                               |

Feature labels are a powerful and flexible way to control storage features,
especially when combined with [rules](rules.html).

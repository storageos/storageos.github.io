---
layout: guide
title: StorageOS Docs - Labels
anchor: manage
module: manage/labels
# Last reviewed by cheryl.hung@storageos.com on 2017-04-13
---

# Labels

Labels are a mechanism for applying metadata to StorageOS objects. You can use
them to annotate or organise your volumes in any way that makes sense for your
organization or app.

A label is a key-value pair that is stored as a string. An object may have
multiple labels but each key must be unique within an object.

You should prefix labels with your organization domain, such as
`example.your-label`. Labels prefixed with `storageos.*` are reserved for
internal use.

### StorageOS feature labels

Applying specific labels to volumes triggers compression, replication and other
storage features. No feature labels are present by default.

To set supported labels, use `storageos volume create --label storageos.feature.cache=true`:

| Feature     | Label                           | Values         | Description                                              |
|:------------|:--------------------------------|:---------------|:---------------------------------------------------------|
| Caching     | `storageos.feature.cache`       | true / false   | Improves read performance at the expense of more memory. |
| Compression | `storageos.feature.nocompress`  | true / false   | Switches off compression of data at rest and in transit. |
| Replication | `storageos.feature.replicas`    | integers [0, 5]| Replicates entire volume across nodes. Typically 1 replica is sufficient (2 copies of the data); more than 2 replicas is not recommended. |
| QoS         | `storageos.feature.throttle`    | true / false   | Deprioritizes traffic by reducing the rate of disk I/O.  |

Feature labels are a powerful and flexible way to control storage features,
especially when combined with [rules](rules.html).

## Using labels with volumes

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

To add labels to a volume:
```bash
$ storageos volume update --label-add env=dev default/volume-name
default/volume-name
```

To remove labels from a volume (note that only the key is specified):
```bash
$ storageos volume update --label-rm env default/volume-name
default/volume-name
```

## Using labels with selectors

[Selectors](selectors.html) can be used to filter on labels with the
`--selector` option. This allows you to quickly search through volumes.

```bash
$ storageos volume ls --selector=env=dev
NAMESPACE/NAME        SIZE                MOUNTED BY          MOUNTPOINT          STATUS              REPLICAS
default/volume-name   5GB                                                         active              0/0
```

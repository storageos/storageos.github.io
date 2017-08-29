---
layout: guide
title: StorageOS Docs - Labels
anchor: manage
module: manage/volumes/labels
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

A client or user can identify a set of objects using a label selector. StorageOS
selectors work the same as [Kubernetes selectors](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#label-selectors).

Selectors can be used to filter on
labels with the `--selector` option. This allows you to quickly search through
volumes.

```bash
$ storageos volume ls --selector=env=dev
NAMESPACE/NAME        SIZE                MOUNTED BY          MOUNTPOINT          STATUS              REPLICAS
default/volume-name   5GB                                                         active              0/0
```

However on rules, selectors define the conditions for triggering a rule. This
creates a rule that configures 2 replicas for volumes with the label `env=prod`:

```bash
$ storageos rule create --namespace default --selector 'env==prod' --label storageos.feature.replicas=2 replicator
default/replicator
```

See [creating and managing rules]({% link _docs/operations/rules.md %}) for
more.

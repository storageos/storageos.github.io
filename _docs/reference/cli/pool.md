---
layout: guide
title: StorageOS Docs - Pools
anchor: reference
module: reference/cli/pool
---

# Pools

```bash
$ storageos pool

Usage:	storageos pool COMMAND

Manage capacity pools

Options:
      --help   Print usage

Commands:
  create      Create a capacity pool
  inspect     Display detailed information on one or more capacity pools
  ls          List capacity pools
  rm          Remove one or more capacity pools
  update      Update a pool

Run 'storageos pool COMMAND --help' for more information on a command.
```

### `storageos pool create`

To create a pool, consisting of nodes with a given label:

```bash
$ storageos pool create no-ha --node-selector storage=fast
no-ha
```

To add a label at time of creation:

```bash
$ storageos pool create production --label env=prod
production
```

### `storageos pool ls`

To list pools:

```bash
$ storageos pool ls
NAME        DEFAULT  NODE_SELECTOR  DEVICE_SELECTOR  NODES  TOTAL    USED
default     true                                     1      40.58GB  4.88%
no-ha       false    storage=fast                    1      40.58GB  4.88%
production  false                                    0      0B       -
```

### `storageos pool inspect`

To inspect the metadata for a given pool:

```bash
$ storageos pool inspect no-ha

[
    {
        "id": "e911c9fe-7d1c-8482-48b6-d0b1283476d4",
        "name": "no-ha",
        "description": "",
        "default": false,
        "nodeSelector": "storage=fast",
        "deviceSelector": "",
        "capacityStats": {
            "totalCapacityBytes": 40576331776,
            "availableCapacityBytes": 38595940352,
            "provisionedCapacityBytes": 0
        },
        "nodes": [
            {
                "id": "ba9eca89-ea10-ce4e-26b9-85331f0b5ee2",
                "hostname": "",
                "address": "192.168.50.100",
                "kvAddr": "",
                "apiPort": 5705,
                "natsPort": 5708,
                "natsClusterPort": 5710,
                "serfPort": 5711,
                "dfsPort": 5703,
                "kvPeerPort": 5707,
                "kvClientPort": 5706,
                "labels": {
                    "storage": "fast"
                },
                "logLevel": "",
                "logFormat": "",
                "logFilter": "",
                "bindAddr": "",
                "deviceDir": "/var/lib/storageos/volumes",
                "join": "",
                "kvBackend": "",
                "debug": false,
                "devices": [
                    {
                        "ID": "59dadbcb-22c6-a01c-8334-1ae9f5ed72c6",
                        "labels": {
                            "default": "true"
                        },
                        "status": "active",
                        "identifier": "/var/lib/storageos/data",
                        "class": "filesystem",
                        "capacityStats": {
                            "totalCapacityBytes": 40576331776,
                            "availableCapacityBytes": 38595940352,
                            "provisionedCapacityBytes": 0
                        },
                        "createdAt": "2018-06-22T10:18:28.528081144Z",
                        "updatedAt": "2018-06-22T11:07:58.876658156Z"
                    }
                ],
                "hostID": 51087,
                "name": "storageos-1",
                "description": "",
                "createdAt": "2018-06-22T10:18:28.523996151Z",
                "updatedAt": "2018-06-22T11:07:58.894679039Z",
                "health": "healthy",
                "healthUpdatedAt": "2018-06-22T10:18:38.83674189Z",
                "versionInfo": {
                    "storageos": {
                        "name": "storageos",
                        "buildDate": "2018-05-25T190132Z",
                        "revision": "f8915fa",
                        "version": "1.0.0",
                        "apiVersion": "1",
                        "goVersion": "go1.9.1",
                        "os": "linux",
                        "arch": "amd64",
                        "kernelVersion": "",
                        "experimental": false
                    }
                },
                "version": "StorageOS 1.0.0 (f8915fa), built: 2018-05-25T190132Z",
                "Revision": "",
                "scheduler": true,
                "cordon": false,
                "drain": false,
                "volumeStats": {
                    "masterVolumeCount": 1,
                    "replicaVolumeCount": 0,
                    "virtualVolumeCount": 0
                },
                "capacityStats": {
                    "totalCapacityBytes": 40576331776,
                    "availableCapacityBytes": 38595940352,
                    "provisionedCapacityBytes": 0
                }
            }
        ],
        "labels": {}
    }
]
```

### `storageos pool rm`

To delete a pool:

```bash
$ storageos pool rm no-ha
no-ha
```

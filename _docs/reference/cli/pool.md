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
$ storageos pool create no-ha --node-selector storage=fast storageos-1-59227
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
NAME                DEFAULT             NODE SELECTOR       DEVICE SELECTOR     NODES               TOTAL               USED
default             true                                                        1                   40.58GB             5.41%
no-ha               false               storage=fast                            0                   0B                  -
production          false                                                       0                   0B                  -
```

### `storageos pool inspect`

To inspect the metadata for a given pool:

```bash
$ storageos pool inspect default
[
    {
        "id": "d064ec07-4d2d-981c-e780-51c59505b309",
        "name": "default",
        "description": "Default storage pool",
        "default": true,
        "nodeSelector": "",
        "deviceSelector": "",
        "capacityStats": {
            "totalCapacityBytes": 0,
            "availableCapacityBytes": 0,
            "provisionedCapacityBytes": 0
        },
        "nodes": [
            {
                "id": "d152ed36-10e4-79d7-0e51-f99e6db143ea",
                "hostname": "",
                "address": "10.1.5.249",
                "kvAddr": "",
                "apiPort": 5705,
                "natsPort": 5708,
                "natsClusterPort": 5710,
                "serfPort": 5711,
                "dfsPort": 5703,
                "kvPeerPort": 5707,
                "kvClientPort": 5706,
                "labels": {},
                "logLevel": "",
                "logFormat": "",
                "logFilter": "",
                "bindAddr": "",
                "deviceDir": "/var/lib/storageos/volumes",
                "join": "",
                "kvBackend": "",
                "debug": false,
                "devices": null,
                "hostID": 53821,
                "name": "joe-PowerEdge-T20",
                "description": "",
                "createdAt": "2018-02-21T09:58:26.423127002Z",
                "updatedAt": "2018-04-27T14:53:55.036833101Z",
                "health": "healthy",
                "healthUpdatedAt": "2018-03-01T21:28:03.5473331Z",
                "versionInfo": {
                    "storageos": {
                        "name": "storageos",
                        "buildDate": "2018-04-27T145258Z",
                        "revision": "8c97066",
                        "version": "8c97066",
                        "apiVersion": "1",
                        "goVersion": "go1.9.1",
                        "os": "linux",
                        "arch": "amd64",
                        "kernelVersion": "",
                        "experimental": true
                    }
                },
                "version": "StorageOS 8c97066, built: 2018-04-27T145258Z",
                "Revision": "",
                "scheduler": true,
                "unschedulable": false,
                "volumeStats": {
                    "masterVolumeCount": 1,
                    "replicaVolumeCount": 0,
                    "virtualVolumeCount": 0
                },
                "capacityStats": {
                    "totalCapacityBytes": 453590114304,
                    "availableCapacityBytes": 315343310848,
                    "provisionedCapacityBytes": 0
                }
            }
        ],
        "labels": null
    }
]
```

### `storageos pool rm`

To delete a pool:

```bash
$ storageos pool rm no-ha
no-ha
```

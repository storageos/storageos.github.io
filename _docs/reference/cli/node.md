---
layout: guide
title: StorageOS Docs - Nodes
anchor: reference
module: reference/cli/node
---

# Nodes

```bash
$ storageos node

Usage:  storageos node COMMAND

Manage nodes

Aliases:
  node, n

Options:
      --help   Print usage

Commands:
  cordon      Put one or more nodes into an unschedulable state
  drain       Migrate volumes from one or more nodes.
  health      Display detailed information on a given node
  inspect     Display detailed information on one or more nodes
  ls          List nodes
  uncordon    Restore one or more nodes from an unschedulable state
  undrain     Stop drain on one or more nodes.
  update      Update a node

Run 'storageos node COMMAND --help' for more information on a command.
```

### `storageos node cordon`

Puts one or more nodes into an unschedulable state, in preparation for upgrading or
decommisioning a node.

```bash
$ storageos node cordon host01
host01
```

### `storageos node drain`

Evicts all volumes from one or more nodes.
In case of draining a node hosting primary volumes, existing replicas will be promoted in different nodes. A replica will be created and promoted to primary if the volume didn't have replication enabled.
All replicas will be relocated to any available nodes in the cluster. If there are non, the replica will remain present. Nodes may not be available for different reasons such as rule configurations, the amount of replicas +1 matching the amount of nodes in the cluster, etc.
While the node is in drain state, it will try to relocate it's volumes. Therefore, adding one or more nodes to the cluster would make volumes to move automatically. In addition, a node in drain state will not host any new volumes.

Any volume mounted in that node will be evicted but still hold the StorageOS mount making the data available for the client, with no downtime.

```bash
$ storageos node drain node-1
node-1
```

### `storageos node inspect`

To view detailed information such as state, port configuration, pool membership,
health, version and capacity in JSON format, inspect the node:

```bash
$ storageos node inspect vol-test-2gb-lon103
[
    {
        "id": "2b59bf5b-53c7-89dd-35c3-0439af6870e0",
        "hostID": 18226,
        "scheduler": false,
        "name": "vol-test-2gb-lon103",
        "address": "46.101.51.16",
        "apiPort": 5705,
        "natsPort": 4222,
        "natsClusterPort": 8222,
        "serfPort": 13700,
        "dfsPort": 17100,
        "description": "",
        "controllerGroups": null,
        "tags": null,
        "labels": null,
        "volumeStats": {
            "masterVolumeCount": 1,
            "replicaVolumeCount": 1,
            "virtualVolumeCount": 0
        },
        "poolStats": {
            "default": {
                "filesystem": {
                    "totalCapacityBytes": 41567956992,
                    "availableCapacityBytes": 39235608576,
                    "provisionedCapacityBytes": 0
                }
            },
            "pool13": {
                "filesystem": {
                    "totalCapacityBytes": 41567956992,
                    "availableCapacityBytes": 39235608576,
                    "provisionedCapacityBytes": 0
                }
            }
        },
        "health": "healthy",
        "healthUpdatedAt": "2017-05-12T17:59:39.841776028Z",
        "versionInfo": {
            "storageos": {
                "name": "storageos",
                "buildDate": "2017-05-12T104014Z",
                "revision": "00ab7b3",
                "version": "0.8.0",
                "apiVersion": "1",
                "goVersion": "go1.7.3",
                "os": "linux",
                "arch": "amd64",
                "kernelVersion": "",
                "experimental": false
            }
        },
        "version": "StorageOS 0.8.0 (00ab7b3), Built: 2017-05-12T104014Z",
        "capacityStats": {
            "totalCapacityBytes": 83135913984,
            "availableCapacityBytes": 78471217152,
            "provisionedCapacityBytes": 0
        }
    }
]
```

### `storageos node ls`

To view the state of your cluster, run:

```bash
$ storageos node ls

NAME                  ADDRESS             HEALTH              SCHEDULER           VOLUMES             TOTAL               USED                VERSION             LABELS
vol-test-2gb-lon101   46.101.50.155       Healthy 2 days      true                M: 0, R: 2          77.43GiB            5.66%               0.8.0 (00ab7b3 rev)
vol-test-2gb-lon102   46.101.50.231       Healthy 2 days      false               M: 1, R: 0          38.71GiB            5.90%               0.8.0 (00ab7b3 rev)
vol-test-2gb-lon103   46.101.51.16        Healthy 2 days      false               M: 1, R: 1          77.43GiB            5.61%               0.8.0 (00ab7b3 rev)
```

The output shows a StorageOS cluster with three nodes named
`vol-test-2gb-lon101`, `vol-test-2gb-lon102` and `vol-test-2gb-lon103`.

- `SCHEDULER`: whether the node contains the scheduler, which is responsible for
  the placement of volumes, performing health checks and providing high
  availability to nodes. A cluster will have exactly one scheduler node.
- `VOLUMES`: the number of master or replica copies of volumes on this node.

### `storageos node uncordon`

Restore one or more nodes after cordoning the node for upgrade.

```bash
$ storageos node uncordon host01
host01
```

### `storageos node undrain`

Stops any draining procedure in place and restores the node to its normal functionality.

```bash
$ storageos node undrain node-1 
node-1
```

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
  connectivity Display detailed connectivity information on one or more nodes
  cordon       Put one or more nodes into an unschedulable state
  delete       Remove an offline node from the cluster.
  drain        Migrate volumes from one or more nodes.
  health       Display detailed information on a given node
  inspect      Display detailed information on one or more nodes
  ls           List nodes
  uncordon     Restore one or more nodes from an unschedulable state
  undrain      Stop drain on one or more nodes.
  update       Update a node

Run 'storageos node COMMAND --help' for more information on a command.
```

### `storageos node connectivity`

Display the latency and status of the connection between different nodes of the
cluster and the services attached to the network started by StorageOS. It shows
whether any node or service can't be connected.

The output can be for all permutations of nodes in the cluster or for one
specific node. 

```bash
$ storageos node connectivity 
SOURCE            NAME                       ADDRESS             LATENCY     STATUS  MESSAGE
ip-172-20-88-241  ip-172-20-100-61.api       172.20.100.61:5705  1.172108ms  OK  
ip-172-20-88-241  ip-172-20-100-61.directfs  172.20.100.61:5703  1.238443ms  OK  
ip-172-20-88-241  ip-172-20-100-61.nats      172.20.100.61:5708  1.088224ms  OK  
ip-172-20-88-241  ip-172-20-32-38.api        172.20.32.38:5705   1.201392ms  OK  
ip-172-20-88-241  ip-172-20-32-38.directfs   172.20.32.38:5703   1.225196ms  OK  
ip-172-20-88-241  ip-172-20-32-38.nats       172.20.32.38:5708   1.097115ms  OK  
ip-172-20-88-241  ip-172-20-39-233.api       172.20.39.233:5705  1.190318ms  OK  
ip-172-20-88-241  ip-172-20-39-233.directfs  172.20.39.233:5703  1.222903ms  OK  
ip-172-20-88-241  ip-172-20-39-233.nats      172.20.39.233:5708  1.286556ms  OK  
ip-172-20-39-233  ip-172-20-100-61.api       172.20.100.61:5705  1.257497ms  OK  
ip-172-20-39-233  ip-172-20-100-61.directfs  172.20.100.61:5703  1.102858ms  OK  
ip-172-20-39-233  ip-172-20-100-61.nats      172.20.100.61:5708  1.240308ms  OK  
ip-172-20-39-233  ip-172-20-32-38.api        172.20.32.38:5705   1.169309ms  OK  
ip-172-20-39-233  ip-172-20-32-38.directfs   172.20.32.38:5703   1.238169ms  OK  
ip-172-20-39-233  ip-172-20-32-38.nats       172.20.32.38:5708   1.120058ms  OK  
ip-172-20-39-233  ip-172-20-88-241.api       172.20.88.241:5705  1.285212ms  OK  
ip-172-20-39-233  ip-172-20-88-241.directfs  172.20.88.241:5703  1.274576ms  OK  
ip-172-20-39-233  ip-172-20-88-241.nats      172.20.88.241:5708  1.257659ms  OK  
ip-172-20-100-61  ip-172-20-32-38.api        172.20.32.38:5705   1.136496ms  OK  
ip-172-20-100-61  ip-172-20-32-38.directfs   172.20.32.38:5703   1.200905ms  OK  
ip-172-20-100-61  ip-172-20-32-38.nats       172.20.32.38:5708   1.227956ms  OK  
ip-172-20-100-61  ip-172-20-39-233.api       172.20.39.233:5705  1.075072ms  OK  
ip-172-20-100-61  ip-172-20-39-233.directfs  172.20.39.233:5703  1.279988ms  OK  
ip-172-20-100-61  ip-172-20-39-233.nats      172.20.39.233:5708  1.239564ms  OK  
ip-172-20-100-61  ip-172-20-88-241.api       172.20.88.241:5705  1.240107ms  OK  
ip-172-20-100-61  ip-172-20-88-241.directfs  172.20.88.241:5703  1.219858ms  OK  
ip-172-20-100-61  ip-172-20-88-241.nats      172.20.88.241:5708  1.309962ms  OK  
ip-172-20-32-38   ip-172-20-100-61.api       172.20.100.61:5705  1.08306ms   OK  
ip-172-20-32-38   ip-172-20-100-61.directfs  172.20.100.61:5703  1.186921ms  OK  
ip-172-20-32-38   ip-172-20-100-61.nats      172.20.100.61:5708  1.233717ms  OK  
ip-172-20-32-38   ip-172-20-39-233.api       172.20.39.233:5705  1.272816ms  OK  
ip-172-20-32-38   ip-172-20-39-233.directfs  172.20.39.233:5703  1.215386ms  OK  
ip-172-20-32-38   ip-172-20-39-233.nats      172.20.39.233:5708  1.272102ms  OK  
ip-172-20-32-38   ip-172-20-88-241.api       172.20.88.241:5705  1.276441ms  OK  
ip-172-20-32-38   ip-172-20-88-241.directfs  172.20.88.241:5703  1.248265ms  OK  
ip-172-20-32-38   ip-172-20-88-241.nats      172.20.88.241:5708  1.328679ms  OK  
```

```bash
$ storageos node connectivity ip-172-20-88-241
SOURCE             NAME                      ADDRESS             LATENCY     STATUS  MESSAGE
ip-172-20-88-241  ip-172-20-100-61.api       172.20.100.61:5705  2.804153ms  OK  
ip-172-20-88-241  ip-172-20-100-61.directfs  172.20.100.61:5703  2.77249ms   OK  
ip-172-20-88-241  ip-172-20-100-61.nats      172.20.100.61:5708  2.791746ms  OK  
ip-172-20-88-241  ip-172-20-32-38.api        172.20.32.38:5705   2.755615ms  OK  
ip-172-20-88-241  ip-172-20-32-38.directfs   172.20.32.38:5703   2.815147ms  OK  
ip-172-20-88-241  ip-172-20-32-38.nats       172.20.32.38:5708   2.526776ms  OK  
ip-172-20-88-241  ip-172-20-39-233.api       172.20.39.233:5705  2.817432ms  OK  
ip-172-20-88-241  ip-172-20-39-233.directfs  172.20.39.233:5703  2.839914ms  OK  
ip-172-20-88-241  ip-172-20-39-233.nats      172.20.39.233:5708  2.894249ms  OK  
```

### `storageos node cordon`

Puts one or more nodes into an unschedulable state, in preparation for upgrading or
decommissioning a node.

```bash
$ storageos node cordon storageos-1
storageos-1
```

### `storageos node delete`

> Only applicable for installations with `KV_BACKEND=etcd`.

Removes a StorageOS node from the cluster. It will only succeed if the node is
`Offline`. All data in that node will be lost, hence it is recommended to drain
the node before decommissioning it.

```bash
$ storageos node delete storageos-1
storageos-1
```

### `storageos node drain`

Evicts all volumes from one or more nodes and puts them into an unschedulable state.

```bash
$ storageos node drain storageos-1
storageos-1
```

### `storageos node inspect`

To view detailed information such as state, port configuration, 
health, version and capacity in JSON format, inspect the node:

```bash
$ storageos node inspect storageos-1
[
    {
        "id": "dafdcc3b-7a7a-14e4-77f4-bcc2070543cf",
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
        "labels": null,
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
                "ID": "e303b84f-b562-c1b0-8434-1ee89f5a9f8d",
                "labels": {
                    "default": "true"
                },
                "status": "active",
                "identifier": "/var/lib/storageos/data",
                "class": "filesystem",
                "capacityStats": {
                    "totalCapacityBytes": 40576331776,
                    "availableCapacityBytes": 38596853760,
                    "provisionedCapacityBytes": 0
                },
                "createdAt": "2018-06-22T09:20:17.499457963Z",
                "updatedAt": "2018-06-22T09:35:17.87048772Z"
            }
        ],
        "hostID": 53012,
        "name": "storageos-1",
        "description": "",
        "createdAt": "2018-06-20T09:22:17.491813738Z",
        "updatedAt": "2018-06-22T09:35:17.876400176Z",
        "health": "healthy",
        "healthUpdatedAt": "2018-06-22T09:20:22.868508782Z",
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
            "masterVolumeCount": 0,
            "replicaVolumeCount": 2,
            "virtualVolumeCount": 0
        },
        "capacityStats": {
            "totalCapacityBytes": 40576331776,
            "availableCapacityBytes": 38596853760,
            "provisionedCapacityBytes": 0
        }
    }
]
```

### `storageos node ls`

To view the state of your cluster, run:

```bash
$ storageos node ls

NAME         ADDRESS         HEALTH              SCHEDULER  VOLUMES     TOTAL    USED   VERSION
storageos-1  192.168.50.100  Healthy 18 minutes  true       M: 0, R: 2  40.58GB  4.88%  1.0.0
storageos-2  192.168.50.101  Healthy 17 minutes  false      M: 1, R: 0  40.58GB  4.88%  1.0.0
storageos-3  192.168.50.102  Healthy 17 minutes  false      M: 1, R: 1  40.58GB  4.88%  1.0.0
```

The output shows a StorageOS cluster with three nodes named
`storageos-1`, `storageos-2` and `storageos-3`.

- `SCHEDULER`: whether the node contains the scheduler, which is responsible for
  the placement of volumes, performing health checks and providing high
  availability to nodes. A cluster will have exactly one scheduler node.
- `VOLUMES`: the number of master or replica copies of volumes on this node.

### `storageos node uncordon`

Restore one or more nodes after cordoning the node for upgrade.

```bash
$ storageos node uncordon storageos-1
storageos-1
```

### `storageos node undrain`

Stops any draining procedure in place and restores the node to its normal functionality.

```bash
$ storageos node undrain storageos-1 
storageos-1
```

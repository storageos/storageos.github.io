---
layout: guide
title: StorageOS Docs - Pools
anchor: reference
module: reference/cli/pool
---

# Pools

Pools are used to create collections of storage resources created from StorageOS
cluster nodes.

## Overview

Pools are used to organize storage resources into common collections such as
class of server, class of storage, location within the datacenter or subnet.
Cluster nodes can participate in more than one pool.

Volumes are provisioned from pools.  If a pool name is not specified when the
volume is created, the default pool name (`default`) will be used.

## Parameters

Pool parameters can be used to set characteristics such as backend storage type,
participating nodes and whether the pool is activated.

### Create a new pool

To create a pool, the pool name is mandatory, and you should specify at least
one node with `--controllers` (the hostname of a StorageOS node) to allocate
storage capacity from:

```bash
$ storageos pool create no-ha --controllers storageos-1-59227
no-ha
```

To add a label at time of creation:

```bash
$ storageos pool create production --label env=prod
production
```

Label metadata:

```json
“labels”: {
    “env”: “prod”
}
```

### List available pools

To list pools use `storageos pool ls [OPTIONS]`:

```bash
$ storageos pool inspect no-ha
POOL NAME           DRIVERS             CONTROLLERS                                               AVAIL               TOTAL               STATUS
default             filesystem          storageos-1-59227, storageos-2-59227, storageos-3-59227   0 B                 0 B                 active
no-ha                                   storageos-1-59227
```

### Inspect a named pool

To inspect the metadata for a given pool (or pools) use
`storageos pool inspect [OPTIONS] POOL [POOL...]`:

```bash
$ storageos pool inspect no-ha
[
   {
       “id”: “025fcde4-d596-57c6-aec8-67e64c1ebf28",
       “name”: “no-ha”,
       “description”: “”,
       “default”: false,
       “defaultDriver”: “”,
       “controllerNames”: [
           “storageos-1-59227”
       ],
       “driverNames”: [],
       “driverInstances”: null,
       “active”: true,
       “capacityStats”: {
           “total_capacity_bytes”: 0,
           “available_capacity_bytes”: 0,
           “provisioned_capacity_bytes”: 0
       },
       “labels”: {
          "env": "prod"
       }
   }
]
```

### Delete a pool

To delete a pool use `storageos pool rm [OPTIONS] POOL] [POOL...]`:

```bash
$ storageos pool rm no-ha
no-ha
```

---
layout: guide
title: Create and manage pools
anchor: manage
module: manage/pools
---

# Pools

Pools are used to create collections of storage resources created from StorageOS cluster nodes.  

## Overview

Pools are used to organize storage resources into common collections such as class of server, class of storage, location within the datacenter or subnet for example.  Cluster nodes can participate in more than one pool.

To provision a volume, a pool must be used as one of the parameters to create one or a volume will be created from the default pool names 'default'.

## Parameters

To take any action on a pool or create a new pool, a number of mandatory and options parameters need to be specified.

### Create a new pool

To create a pool, the minimum set of (mandatory) parameters required is a pool name and at least one node name to create the pool from `storageos pool create [OPTIONS] [POOL]`:

```
$ storageos pool create no-ha --controllers storageos-1-59227
no-ha
```

To add a label at time of creation:

```
$ storageos pool create production --label env:prod
production
```

Label metadata:

```
“labels”: {
           “env:prod”: “”
       }
```

### List available pools

To list the newly created pool use `storageos pool ls [OPTIONS]`: 

```
$ storageos pool inspect no-ha
POOL NAME           DRIVERS             CONTROLLERS                                               AVAIL               TOTAL               STATUS
default             filesystem          storageos-1-59227, storageos-2-59227, storageos-3-59227   0 B                 0 B                 active
no-ha                                   storageos-1-59227
```

### Inspect a named pool

To inspect the metadata for a given pool (or pools) use `storageos pool inspect [OPTIONS] POOL [POOL...]`: 

```
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
       “labels”: {}
   }
]
```

### Delete a pool

To delete a pool use `storageos pool rm [OPTIONS] POOL] [POOL...]`:

```
$ storageos pool rm no-ha
no-ha
```
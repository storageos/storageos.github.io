---
layout: guide
title: StorageOS Docs - Pools
anchor: reference
module: reference/cli/pool
---

# Pools

(Download and install the StorageOS CLI [here]({%link _docs/reference/cli/index.md %})

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

Run 'storageos pool COMMAND --help' for more information on a command.
```

### `storageos pool create`

To create a pool:

```bash
$ storageos pool create no-ha --controllers storageos-1-59227
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
NAME                DRIVERS             NODES               TOTAL               USED                STATUS
default             filesystem          1                   40.58GB             5.41%               active
no-ha                                   0                   0B                  -                   active
```

### `storageos pool inspect`

To inspect the metadata for a given pool:

```bash
$ storageos pool inspect no-ha
[
   {
       "id": "025fcde4-d596-57c6-aec8-67e64c1ebf28",
       "name": "no-ha",
       "description": ""
       "default": false,
       "defaultDriver": "",
       "controllerNames": [
           "storageos-1-59227"
       ],
       "driverNames": [],
       "driverInstances": null,
       "active": true,
       "capacityStats": {
           "total_capacity_bytes": 0,
           "available_capacity_bytes": 0,
           "provisioned_capacity_bytes": 0
       },
       "labels": {
          "env": "prod"
       }
   }
]
```

### `storageos pool rm`

To delete a pool:

```bash
$ storageos pool rm no-ha
no-ha
```

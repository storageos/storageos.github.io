---
layout: guide
title: Command line interface
anchor: reference
module: reference/cli
---

# Command Line Interface

## Overview

The `storageos` command line interface (CLI) is used to manage cluster-wide
configuration. `storageos` is designed to be familiar to Docker CLI users.

## Installation

On 64-bit Linux [(view other platforms)](https://github.com/storageos/go-cli/releases):

```bash
$ curl -sSL https://github.com/storageos/go-cli/releases/download/latest/storageos_linux_amd64 > storageos
$ chmod +x storageos
$ export STORAGEOS_USERNAME=storageos STORAGEOS_PASSWORD=storageos STORAGEOS_HOST=127.0.0.1
$ export PATH=$PATH:.
```

## Usage

```
$ storageos

Usage:	storageos COMMAND

Converged storage for containers

Options:
      --config string      Location of client config files (default "/home/vagrant/.storageos")
  -D, --debug              Enable debug mode
      --help               Print usage
  -H, --host list          Node endpoint(s) to connect to (will override STORAGEOS_HOST env variable
                           value) (default [])
  -l, --log-level string   Set the logging level ("debug"|"info"|"warn"|"error"|"fatal") (default "info")
  -p, --password string    API password (will override STORAGEOS_PASSWORD env variable value)
  -u, --username string    API username (will override STORAGEOS_USERNAME env variable value)
  -v, --version            Print version information and quit

Management Commands:
  namespace   Manage namespaces
  pool        Manage capacity pools
  rule        Manage rules
  system      Manage StorageOS
  volume      Manage volumes

Commands:
  version     Show the StorageOS version information

Run 'storageos COMMAND --help' for more information on a command.
```

### Authentication

If you see `API error (401): Unauthorized`, you need to provide the correct
credentials via environment variables. The default installation creates a single
user with username `storageos` and password `storageos`.

```bash
export STORAGEOS_USERNAME=storageos STORAGEOS_PASSWORD=storageos
```

Set `STORAGEOS_HOST` for remote authentication:

```bash
export STORAGEOS_HOST=<ip address:port>
```

Credentials can be overridden with the `-u`, `-p`  and `-h` flags.

```
$ storageos -u storageos -p storageos volume list
NAMESPACE/NAME         SIZE                MOUNTED BY          STATUS
default/test-vol       11 GB                                   active
```

## Management Commands

Each of the storageos management commands requires a subcommand to run. Use `storageos COMMAND --help` to view command flags.

| Command                                  | Description                                                    | Subcommands                   |
|------------------------------------------|----------------------------------------------------------------|-------------------------------|
| [volume](../manage/volumes.html)       | StorageOS data volumes                                         | `create inspect ls rm update` |
| [rule](../manage/rules.html)           | Policy enforcement based on labels.                            | `inspect ls rm update`        |
| [namespace](../manage/namespaces.html) | Namespaces help different projects or teams organize volumes.  | `create inspect ls rm update` |
| [pool](../manage/pools.html)           | A collection of storage resources that can be provisioned from.| `create inspect ls rm`        |

Use `storageos COMMAND SUBCOMMAND --help` to view subcommand flags.

## Common operations

The following set of examples should help familiarize yourself with running commonly used `storageos` operations.

### volume

Create a new volume in a new namespace.

```
$ storageos volume create myvolume -n legal
legal/myvolume
```

Check if a volume is mounted.

```
storageos volume inspect legal/myvolume | grep mounted
        "mounted": false,
```

Create a 10GB scratch volume from no-ha pool

```
$ storageos volume create scratch1 -p no-ha -s 10 -f xfs -n legal
legal/scratch1
```

Inspect volume properties

```
$ storageos volume inspect legal/scratch1
[
    {
        "id": "770620f3-7a93-4b90-8349-4b0d2ae88129",
        "inode": 0,
        "name": "scratch1",
        "size": 10,
        "pool": "no-ha",
        "fsType": "xfs",
        "description": "",
        "labels": {
            "storageos.driver": "filesystem"
        },
        "namespace": "legal",
        "master": {
            "id": "",
            "inode": 0,
            "controller": "",
            "health": "",
            "status": "",
            "createdAt": "0001-01-01T00:00:00Z"
        },
        "mounted": false,
        "replicas": null,
        "health": "",
        "status": "failed",
        "statusMessage": "",
        "createdAt": "0001-01-01T00:00:00Z",
        "createdBy": ""
    }
]
```

### rule

Create a new rule in default namespace:

```
$ storageos rule create --namespace default --selector env=prod --operator == --action add --label storageos.feature.replicas=2 replicator
default/replicator
```

List rules:

```
$ storageos rule ls
NAMESPACE/NAME        OPERATOR            SELECTOR                       ACTION              LABELS
default/dev-marker    notin               storageos.feature.replicas=1   add                 env=dev
default/prod-marker   gt                  storageos.feature.replicas=1   add                 env=prod
default/replicator    ==                  env=prod                       add                 storageos.feature.replicas=2
default/uat-marker    lt                  storageos.feature.replicas=2   add                 env=uat
```

Inspect rule:

```
$ storageos rule inspect default/replicator
[
    {
        "id": "2490e656-a381-46ca-f349-9a0b61822a2e",
        "name": "replicator",
        "namespace": "default",
        "description": "",
        "active": true,
        "weight": 5,
        "operator": "==",
        "action": "add",
        "selectors": {
            "env": "prod"
        },
        "labels": {
            "storageos.feature.replicas": "2"
        }
    }
]
```

Delete rule:

```
$ storageos rule rm default/replicator
default/replicator
```
### namespace

Create a new namespace.

```
$ storageos namespace create legal --description compliance-volumes
legal
```

View namespaces.

```
$ storageos namespace ls -q
default
legal
performance
```

Does a namespace have labels applied

```
$ storageos namespace inspect legal | grep labels
        "labels": null,
```

Remove a namespace

```
$ storageos namespace rm legal
legal
```

**Note**: Removing a namespace will also remove all unmounted volumes contained
in it without warning.  You must specify the `--force` flag if you wish to
delete a namespace with mounted volumes.

### pool

Create a new no-ha pool comprising one node
```
$ storageos pool create no-ha --controllers storageos-1-59227
no-ha
```

List available pools

```
$ storageos pool ls
POOL NAME           DRIVERS             CONTROLLERS                                               AVAIL               TOTAL               STATUS
default             filesystem          storageos-1-59227, storageos-2-59227, storageos-3-59227   0 B                 0 B                 active
no-ha                                   storageos-1-59227                                         0 B                 0 B                 active
```

Delete pool

```
$ storageos pool rm no-ha
no-ha
```

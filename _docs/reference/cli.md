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
| `volume`       | StorageOS data volumes                                         | `create inspect ls rm update` |
| `rule`           | Policy enforcement based on labels.                            | `inspect ls rm update`        |
| `namespace` | Namespaces help different projects or teams organize volumes.  | `create inspect ls rm update` |
| `pool`          | A collection of storage resources that can be provisioned from.| `create inspect ls rm`        |

Use `storageos COMMAND SUBCOMMAND --help` to view subcommand flags.

Read the guides for example usage on each command.

* [Create and manage volumes](../manage/volumes.html)
* [Create and manage rules](../manage/rules.html)
* [Create and manage namespaces](../manage/namespaces.html)
* [Create and manage pools](../manage/pools.html)

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

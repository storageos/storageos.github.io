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

[View supported platforms](https://github.com/storageos/go-cli/releases)

```bash
curl -sSL https://github.com/storageos/go-cli/releases/download/v0.0.1/storageos_linux_amd64 > storageos
chmod +x storageos
```

## Usage

```
$ storageos

Usage:	storageos COMMAND

Converged storage for containers

Options:
      --config string      Location of client config files (default "~/.storageos")
  -D, --debug              Enable debug mode
      --help               Print usage
  -H, --host list          Daemon socket(s) to connect to (default [])
  -l, --log-level string   Set the logging level ("debug"|"info"|"warn"|"error"|"fatal") (default "info")
  -p, --password string    API password
      --tls                Use TLS; implied by --tlsverify
      --tlscacert string   Trust certs signed only by this CA (default "~/.storageos/ca.pem")
      --tlscert string     Path to TLS certificate file (default "~/.storageos/cert.pem")
      --tlskey string      Path to TLS key file (default "~/.storageos/key.pem")
      --tlsverify          Use TLS and verify the remote
  -u, --username string    API username
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

If you see `API error (401): Unauthorized`, you need to provide the correct credentials via environment variables. The default installation creates a single user with username `storageos` and password `storageos`.

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

Each of the storageos management commands requires a subcommand to run.

Use `storageos COMMAND SUBCOMMAND --help` to view the available available option
flags.

### Commands

There are five management commands available from the storageos CLI

| Command     | Description                                                                        |
|-------------|-------------------------------------------------------------------------------------------|
| `namespace` | A StorageOS namespace is a class where you organize your StorageOS volumes.        |
|             | By default, volumes will be created in the *default* namespace.                    |
| `pool`      | A StorageOS pool is a collection of storage resources that can be provisioned from.|
|             | By default, volumes will be created from the *default* pool.                       |
| `rule`      | StorageOS *rules* are created using collections of *labels* to define a set of     |
|             | conditions to apply a policy to. There are no default rules defined out of the box.|
| `system`    | StorageOS *system* refers to the running StorageOS process                         |
| `volume`    | StorageOS volumes are created in a defined *namespace* from a defined *pool*.  If no|
|             | values are provided volumes will be created in the default pool and namespace.     |


### Flags and Arguments

For each management subcommand there are several options.  Each option supports a number of flags which are different for each management command.

**Note**: For a list of subcommand argument flags and their meanings, use `COMMAND SUBCOMMAND flag --help`

| Flag        | Description                   | Applies to                                  |
|-------------|-------------------------------------------------------------------------------------------|
| `create`    | Create object                 | `namespece` `pool` `rule` `system` `volume` |
| `events`    | List event information        | `system`                                    |
| `inspect`   | Display object properties     | `namespece` `pool` `rule` `system` `volume` |
| `ls`        | List object collection        | `namespece` `pool` `rule` `system` `volume` |
| `rm`        | Remove object from collection | `namespece` `pool` `rule` `system` `volume` |
| `update`    | Update object                 | `namespece` `volume`                        |


## Examples: Common operations

The following set of examples should help familiarize yourself with running commonly used storageos operations.

### namespace

Create a new namespace

```
$ storageos namespace create legal --description compliance-volumes
legal
```

Output a list of just the namespace names

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


### volume

Create a new volume in a new namespace

```
$ storageos volume create myvolume -n legal
legal/myvolume
```

Is new volume mounted?

```
storageos volume inspect legal/myvolume | grep mounted
        "mounted": false,
```

Create a 10GB scratch volume from no-ha pool

```
$ storageos volume create scratch1 -p no-ha -s 10 -f xfs -n legal
legal/scratch1
```

Inspect new volume properties

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

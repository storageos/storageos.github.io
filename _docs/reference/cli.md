---
layout: guide
title: StorageOS Docs - Command line interface
anchor: reference
module: reference/cli
---

# Command Line Interface

## Overview

The `storageos` command line interface (CLI) is used to manage cluster-wide
configuration. `storageos` is designed to be familiar to Docker CLI users.

## Usage

```bash
$ storageos

Usage:  storageos COMMAND

Converged storage for containers

Options:
      --config string      Location of client config files (default
                           "/root/.storageos")
  -D, --debug              Enable debug mode
      --help               Print usage
  -H, --host list          Node endpoint(s) to connect to (will override
                           STORAGEOS_HOST env variable value) (default [])
  -l, --log-level string   Set the logging level
                           ("debug"|"info"|"warn"|"error"|"fatal")
                           (default "info")
  -p, --password string    API password (will override STORAGEOS_PASSWORD
                           env variable value)
  -u, --username string    API username (will override STORAGEOS_USERNAME
                           env variable value)
  -v, --version            Print version information and quit

Management Commands:
  namespace   Manage namespaces
  node        Manage nodes
  pool        Manage capacity pools
  rule        Manage rules
  system      Manage StorageOS
  volume      Manage volumes

Commands:
  version     Show the StorageOS version information

Run 'storageos COMMAND --help' for more information on a command.
```

## Management Commands

Each of the storageos management commands requires a subcommand to run. Use
`storageos COMMAND --help` to view command flags.

| Command     | Subcommands                   | Description                                                    |
|-------------|-------------------------------|----------------------------------------------------------------|
| `volume`    | `create inspect ls rm update` | StorageOS data volumes.                                        |
| `node`      | `ls inspect`                  | Node information.                                              |
| `rule`      | `create inspect ls rm update` | Policy enforcement based on labels.                            |
| `namespace` | `create inspect ls rm update` | Namespaces help different projects or teams organize volumes.  |
| `pool`      | `create inspect ls rm`        | A collection of storage resources that can be provisioned from.|

Use `storageos COMMAND SUBCOMMAND --help` to view subcommand flags.

Read the guides for how to use each command.

* [Create and manage volumes]({% link _docs/manage/volumes.md %})
* [Create and manage rules]({% link _docs/manage/rules.md %})
* [Create and manage namespaces]({% link _docs/manage/namespaces.md %})
* [Create and manage pools]({% link _docs/manage/pools.md %})
* [Cluster information]({% link _docs/manage/nodes.md %})

## Installation

[Installing the StorageOS CLI]({% link _docs/manage/cli.md %})

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

```bash
$ storageos -u storageos -p storageos volume list
NAMESPACE/NAME        SIZE                MOUNTED BY          MOUNTPOINT          STATUS              REPLICAS            LOCATION
default/repl-volume   5GB                                                         active              2/2                 vol-test-2gb-lon103 (healthy)
```

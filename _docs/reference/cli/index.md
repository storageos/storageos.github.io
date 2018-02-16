---
layout: guide
title: StorageOS Docs - Command line interface
anchor: reference
module: reference/cli/index
---

# Command Line Interface

## Overview

The `storageos` command line interface (CLI) is used to manage cluster-wide
configuration. It is [open source](https://github.com/storageos/go-cli).

## Installation

Install to `/usr/local/bin`:
```bash
# linux/amd64
curl -sSLo storageos https://github.com/storageos/go-cli/releases/download/0.10.0/storageos_linux_amd64 && chmod +x storageos && sudo mv storageos /usr/local/bin/
# OS X/amd64
curl -sSLo storageos https://github.com/storageos/go-cli/releases/download/0.10.0/storageos_darwin_amd64 && chmod +x storageos && sudo mv storageos /usr/local/bin/
```

You will need to provide the correct credentials to connect to the API. The
default installation creates a single user with username `storageos` and
password `storageos`:

```bash
# Use environment variables
export STORAGEOS_USERNAME=storageos STORAGEOS_PASSWORD=storageos

# Authenticate to remote host
export STORAGEOS_HOST=10.1.5.249

# Use flags to override environment variables on any command
storageos -u storageos -p storageos volume list
NAMESPACE/NAME        SIZE                MOUNTED BY          MOUNTPOINT          STATUS              REPLICAS            LOCATION
default/repl-volume   5GB                                                         active              2/2                 vol-test-2gb-lon103 (healthy)

# Store credentials
storageos login 10.1.5.249
Username: storageos
Password:
Credentials verified

# Forget credentials
storageos logout 10.1.5.249
```

## Usage

```bash
$ storageos

Usage:	storageos COMMAND

Converged storage for containers.

By using this product, you are agreeing to the terms of the the StorageOS Ltd. End
User Subscription Agreement (EUSA) found at: https://storageos.com/legal/#eusa

Options:
      --config string     Location of client config files (default "/Users/cheryl/.storageos")
  -D, --debug             Enable debug mode
      --help              Print usage
  -H, --host list         Node endpoint(s) to connect to (will override STORAGEOS_HOST env variable value)
                          (default [])
  -p, --password string   API password (will override STORAGEOS_PASSWORD env variable value)
  -u, --username string   API username (will override STORAGEOS_USERNAME env variable value)
  -v, --version           Print version information and quit

Management Commands:
  cluster                 Manage clusters
  namespace               Manage namespaces
  node                    Manage nodes
  policy                  Manage policies
  pool                    Manage capacity pools
  rule                    Manage rules
  user                    Manage users
  volume                  Manage volumes

Commands:
  login                   Store login credentials for a given storageos host
  logout                  Delete stored login credentials for a given storageos host
  version                 Show the StorageOS version information

Run 'storageos COMMAND --help' for more information on a command.
```

## Cheatsheet

| Command     | Subcommand                    | Description                                                    |
|-------------|-------------------------------|----------------------------------------------------------------|
| `cluster`   | `create health inspect rm`    | Cluster information.                                           |
| `login`     |                               | Store login credentials for a given StorageOS host.            |
| `logout`    |                               | Delete stored login credentials for a given StorageOS host.    |
| `namespace` | `create inspect ls rm update` | Namespaces help different projects or teams organize volumes.  |
| `node`      | `inspect ls`                  | Node information.                                              |
| `policy`    | `create inspect ls rm`        | Define how resources are accessed by users and groups.         |
| `pool`      | `create inspect ls rm`        | A collection of storage resources for provisioning volumes.    |
| `rule`      | `create inspect ls rm update` | Rules define label-based policies to apply to volumes.         |
| `user`      | `create inspect ls rm update` | User and group management.                                     |
| `version`   |                               | Display the version.                                           |
| `volume`    | `create inspect ls rm update` | StorageOS data volumes.                                        |

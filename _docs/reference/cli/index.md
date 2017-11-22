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
curl -sSLo storageos https://github.com/storageos/go-cli/releases/download/0.9.1/storageos_linux_amd64 && chmod +x storageos && sudo mv storageos /usr/local/bin/
# OS X/amd64
curl -sSLo storageos https://github.com/storageos/go-cli/releases/download/0.9.1/storageos_darwin_amd64 && chmod +x storageos && sudo mv storageos /usr/local/bin/
```

You will need to provide the correct credentials. The default installation
creates a single user with username `storageos` and password `storageos`, which
can be set as environment variables:

```bash
export STORAGEOS_USERNAME=storageos STORAGEOS_PASSWORD=storageos
```

For remote authentication, set `STORAGEOS_HOST`:

```bash
export STORAGEOS_HOST=10.1.5.249
```

Credentials can be overridden with the `-u`, `-p`  and `-H` flags.

```bash
$ storageos -u storageos -p storageos volume list
NAMESPACE/NAME        SIZE                MOUNTED BY          MOUNTPOINT          STATUS              REPLICAS            LOCATION
default/repl-volume   5GB                                                         active              2/2                 vol-test-2gb-lon103 (healthy)
```

The storageos CLI also provides a credential store for setting these values long-term.

```bash
$ storageos login 10.1.5.249
Username: storageos
Password:
Credentials verified
```

The CLI will automatically use the stored credentials when contacting a known host (if not overridden by `-u` or `-p`).
To prevent this, use the logout command to forget the credentials.

```bash
$ storageos logout 10.1.5.249
```


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
  cluster     Manage clusters
  namespace   Manage namespaces
  node        Manage nodes
  pool        Manage capacity pools
  rule        Manage rules
  volume      Manage volumes

Commands:
  version     Show the StorageOS version information

Run 'storageos COMMAND --help' for more information on a command.
```

## Environment variables

The CLI supports the following environment variables.  Any flags set in the
command line override their corresponding environment variables.

* `STORAGEOS_USERNAME`: Username for API authentication, equivalent of -u.
* `STORAGEOS_PASSWORD`: Password for API authentication, equivalent of -p.
* `STORAGEOS_HOST`: ip_address to connect to, equivalent of -H.

## Management Commands

Each of the `storageos` management commands requires a subcommand to run. Use
`storageos COMMAND --help` to view command flags.

| Command     | Subcommands                   | Description                                                    |
|-------------|-------------------------------|----------------------------------------------------------------|
| `volume`    | `create inspect ls rm update` | StorageOS data volumes.                                        |
| `node`      | `ls inspect`                  | Node information.                                              |
| `rule`      | `create inspect ls rm update` | Policy enforcement based on labels.                            |
| `namespace` | `create inspect ls rm update` | Namespaces help different projects or teams organize volumes.  |
| `pool`      | `create inspect ls rm`        | A collection of storage resources that can be provisioned from.|

Use `storageos COMMAND SUBCOMMAND --help` to view subcommand flags.

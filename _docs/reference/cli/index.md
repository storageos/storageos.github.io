---
layout: guide
title: StorageOS Docs - Command line interface
anchor: reference
module: reference/cli
---

# Command Line Interface

The `storageos` command line interface (CLI) is used to manage cluster-wide
configuration.

## Installation

```bash
# linux/amd64
curl -sSLo storageos https://github.com/storageos/go-cli/releases/download/{{ site.latest_cli_version }}/storageos_linux_amd64 && chmod +x storageos && sudo mv storageos /usr/local/bin/
# OS X/amd64
curl -sSLo storageos https://github.com/storageos/go-cli/releases/download/{{ site.latest_cli_version }}/storageos_darwin_amd64 && chmod +x storageos && sudo mv storageos /usr/local/bin/
```


You will need to provide the correct credentials to connect to the API. The
default installation creates a single user with username `storageos` and
password `storageos`:

```bash
# Use environment variables
export STORAGEOS_USERNAME=storageos STORAGEOS_PASSWORD=storageos

# Access StorageOS running on a remote host by providing the IP address
export STORAGEOS_HOST=10.1.5.249
```

## Usage

```bash
$ storageos

Usage:	storageos COMMAND

Converged storage for containers.

By using this product, you are agreeing to the terms of the the StorageOS Ltd. End
User Subscription Agreement (EUSA) found at: https://storageos.com/legal/#eusa

To be notified about stable releases and latest features, sign up at https://my.storageos.com.

Options:
      --config string      Location of client config files (default "/home/$USER/.storageos")
  -D, --debug              Enable debug mode
  -d, --discovery string   The discovery endpoint. Defaults to https://discovery.storageos.cloud (will override STORAGEOS_DISCOVERY env variable value)
      --help               Print usage
  -H, --host string        Node endpoint(s) to connect to (will override STORAGEOS_HOST env variable value)
  -p, --password string    API password (will override STORAGEOS_PASSWORD env variable value)
  -u, --username string    API username (will override STORAGEOS_USERNAME env variable value)
  -v, --version            Print version information and quit

Management Commands:
  cluster                 Manage clusters
  licence                 Manage the licence
  logs                    View and manage node logs on the active cluster
  namespace               Manage namespaces
  node                    Manage nodes
  policy                  Manage policies
  pool                    Manage capacity pools
  rule                    Manage rules
  user                    Manage users
  volume                  Manage volumes

Commands:
  install-bash-completion Install bash completion for the storageos cli
  login                   Store login credentials for a given storageos host
  logout                  Delete stored login credentials for a given storageos host
  version                 Show the StorageOS version information

Run 'storageos COMMAND --help' for more information on a command.
```

## Formatting CLI Output

StorageOS CLI output can be formatted using the `--format` option. The strings
that are passed to `--format` are based on [Go
templates](https://golang.org/pkg/text/template/).

StorageOS CLI v1.2.0 added help for the `--format` option. The help can be
accessed by passing `--format help` to StorageOS CLI commands to get context
specific help.

```bash
$ storageos volume ls --format help
```

## Cheatsheet

| Command       | Subcommand                                               | Description                                                      |
| ------------- | -------------------------------                          | ---------------------------------------------------------------- |
| `cluster`     | `create health inspect rm`                               | Cluster information.                                             |
| `licence`     | `apply inspect rm`                                       | Manage licences                                                  |
| `logs`        | `view`                                                   | View and manage node logs.                                       |
| `namespace`   | `create inspect ls rm update`                            | Namespaces help different projects or teams organize volumes.    |
| `node`        | `cordon drain health inspect ls uncordon undrain update` | Node information.                                                |
| `policy`      | `create inspect ls rm`                                   | Define how resources are accessed by users and groups.           |
| `pool`        | `create inspect ls rm`                                   | A collection of storage resources for provisioning volumes.      |
| `rule`        | `create inspect ls rm update`                            | Rules define label-based policies to apply to volumes.           |
| `user`        | `create inspect ls rm update`                            | User and group management.                                       |
| `volume`      | `create inspect ls rm update`                            | StorageOS data volumes.                                          |

[Source is available on Github](https://github.com/storageos/go-cli).

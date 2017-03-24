---
layout: guide
title: Command line interface
anchor: reference
module: reference/cli
---

# Command Line Interface

## Overview

The `storageos` command line interface is used to manage cluster-wide configuration. `storageos` is designed to be familiar to Docker CLI users.

## Usage

```bash
storageos [OPTIONS] COMMAND [ARG...]
```

## Options

```bash
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
```

## Environment variables

`storageos` supports the following environment variables. Any flags set in the command line override their corresponding environment variables.

* `STORAGEOS_USERNAME` Username for API authentication, equivalent of -u.
* `STORAGEOS_PASSWORD` Password for API authentication, equivalent of -p.
* `STORAGEOS_HOST` ip_address:port to connect to, equivalent of -H.

## Commands

Run `storageos COMMAND SUBCOMMAND --help` to see flags.

```bash
Usage:	storageos namespace COMMAND

Commands:
  create      Create a namespace
  inspect     Display detailed information on one or more namespaces
  ls          List namespaces
  rm          Remove one or more namespaces
  update      Update a namespace
```

```bash
Usage:	storageos pool COMMAND

Commands:
  create      Create a capacity pool
  inspect     Display detailed information on one or more capacity pools
  ls          List capacity pools
  rm          Remove one or more capacity pools
```

```bash
Usage:	storageos rule COMMAND

Commands:
  create      Create a rule
  inspect     Display detailed information on one or more rules
  ls          List rules
  rm          Remove one or more rules
  update      Update a rule
```

```bash
Usage:	storageos volume COMMAND

Commands:
  create      Create a volume
  inspect     Display detailed information on one or more volumes
  ls          List volumes
  rm          Remove one or more volumes
  update      Update a volume
```

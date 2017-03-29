---
layout: guide
title: Command line interface
anchor: reference
module: reference/cli
---

# StorageOS Command Line

## storageos Overview

The `storageos` command line interface (CLI) is used to manage StorageOS cluster-wide storage configuration and has been implemented with a familiar Docker and Kuberneres CLI look and feel for taking common command line arguments:

`storageos [OPTIONS] COMMAND [SUBCOMMAND] [flag] [ARG...]`

`storageos [ --help | -v | --version ]`

## Syntax

To list available commands, either run `storageos` with no parameters or envoke storageos help with the `--help` option:

```
$ storageos

Usage:	storageos COMMAND

Converged storage for containers

Options:
      --config string      Location of client config files (default "/root/.storageos")
  -D, --debug              Enable debug mode
      --help               Print usage
  -H, --host list          Daemon socket(s) to connect to (default [])
  -l, --log-level string   Set the logging level ("debug"|"info"|"warn"|"error"|"fatal") (default "info")
  -p, --password string    API password
      --tls                Use TLS; implied by --tlsverify
      --tlscacert string   Trust certs signed only by this CA (default "/root/.storageos/ca.pem")
      --tlscert string     Path to TLS certificate file (default "/root/.storageos/cert.pem")
      --tlskey string      Path to TLS key file (default "/root/.storageos/key.pem")
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

## Description

To run any storageos command you need API authorization.  This can be achieved directly from the command line using the `-u` and `-p` username and password options.

```
$ storageos volume list
API error (401): Unauthorized

$ storageos -u storageos -p storageos volume list
NAMESPACE/NAME         SIZE                MOUNTED BY          STATUS
default/test-vol       11 GB                                   active
```

### Environment variables

In addition to the username and password flag options, the following environment variables can be exported removing the need to enter the command line options each time.

<!--- the escape characters are used to compensate for no cell padding - these can be removed once the CSS has been updated or the table will be unreadable --->

| Environment Variable | &emsp; Description                     | &emsp; Equivalent to |
|----------------------|----------------------------------------|---------------------:|
| `STORAGEOS_USERNAME` | &emsp; Username for API authentication | &emsp; `-u`          |
| `STORAGEOS_PASSWORD` | &emsp; Password for API authentication | &emsp; `-p`          |
| `STORAGEOS_HOST`     | &emsp; Daemon socket(s) to connect to  | &emsp; `-H`          |
|                      |                                        |                      |

<!--- a blank row is required to add a new line; not required before a new heading --->

To set a default username and password, simply export the values for each environment variable

```bash
export STORAGEOS_USERNAME=storageos STORAGEOS_PASSWORD=storageos
```

{% icon fa-pencil-square-o %} **Note**: The -u and -p options specified from the command line override the values from the corresponding environment variables

{% icon fa-pencil-square-o %} **Note**: Unless otherise noted, assume username and password environment variables have been exported for the examples that follow

## Management Commands

Each of the storageos management commands requires a subcommand to run.  

Use `storageos COMMAND SUBCOMMAND --help` to view the available available option flags.

### Commands

There are five management commands available from the storageos CLI

| Command     | &emsp; Description                                                                        |
|-------------|-------------------------------------------------------------------------------------------|
| `namespace` | &emsp; A StorageOS namespace is a class where you organize your StorageOS volumes.        |
|             | &emsp; By default, volumes will be created in the *default* namespace.                    |
| `pool`      | &emsp; A StorageOS pool is a collection of storage resources that can be provisioned from.|
|             | &emsp; By default, volumes will be created from the *default* pool.                       |
| `rule`      | &emsp; StorageOS *rules* are created using collections of *labels* to define a set of     |
|             | &emsp; conditions to apply a policy to. There are no default rules defined out of the box.|
| `system`    | &emsp; StorageOS *system* refers to the running StorageOS process                         |
| `volume`    | &emsp; StorageOS volumes are created in a defined *namespace* from a defined *pool*.  If no| 
|             | &emsp; values are provided volumes will be created in the default pool and namespace.     |


### Flags and Arguments

For each management subcommand there are several options.  Each option supports a number of flags which are different for each management command.

{% icon fa-pencil-square-o %} **Note**: For a list of subcommand argument flags and their meanings, use `COMMAND SUBCOMMAND flag --help`

| Flag        | &emsp; Description                   | &emsp; Applies to                                  |
|-------------|-------------------------------------------------------------------------------------------|
| `create`    | &emsp; Create object                 | &emsp; `namespece` `pool` `rule` `system` `volume` |
| `events`    | &emsp; List event information        | &emsp; `system`                                    |
| `inspect`   | &emsp; Display object properties     | &emsp; `namespece` `pool` `rule` `system` `volume` |
| `ls`        | &emsp; List object collection        | &emsp; `namespece` `pool` `rule` `system` `volume` |
| `rm`        | &emsp; Remove object from collection | &emsp; `namespece` `pool` `rule` `system` `volume` |
| `update`    | &emsp; Update object                 | &emsp; `namespece` `volume`                        |


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
{% icon fa-pencil-square-o %} **Note**: Removing a namespace will also remove all (unmounted) volumes contained in it without warning.

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

Where did my volume go

```
$ storageos volume inspect legal/scratch |grep no-ha
        "pool": "no-ha",
```

{% icon fa-pencil-square-o %} **Note***: While the pool is deleted, the volume object still remains and maintains its old pool name.


### rule

Create a test rule

```
storageos rule create test
API error (404): 404 page not found
```

### system

Get real time events from the server, supports just one flag `events`

```
storageos system events
```
-hangs-



### volume

Create a new voume and new namespace

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


## API Error Codes

API error (401): \<error_string\> e.g. Unauthorized

API error (404): \<error_string\> e.g. 404 page not found

API error (500): \<error_string\> e.g. Internal Server Error \| namespace name is not valid
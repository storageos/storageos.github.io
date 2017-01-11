---
layout: guide
title: Command line reference
anchor: reference
module: reference/cli
---

# Command line reference

The command line interface (CLI) can be run with Docker.

## Example Usage

```
# docker run quay.io/storageos/storageos:beta
usage: storageos [--version] [--help] <command> [<args>]

Available commands are:
    batch           Enables batch updates
    bootstrap       Loads inital data
    client          Runs a StorageOS client for mounting remote StorageOS volumes
    controller      Reports on controller status
    dataplane       Starts dataplane
    event           Manages events
    health          Checks StorageOS node health and returns status
    host            Manages clients
    pool            Manages storage pools
    presentation    Manages presentation groups
    scan            Scans for hardware changes
    server          Runs a StorageOS server
    tag             Manages tags
    tagtype         Manages tag types
    template        Manages auto-naming templates
    version         Prints the StorageOS version
    volume          Manages volumes
```

## Environment

**STORAGEOS_USER**: The username to authenticate to the API with.

**STORAGEOS_PASSWORD**: The password to authenticate to the API with.

**STORAGEOS_API_ADDR**: The ip address and port of the API endpoint.  Defaults to `localhost:8000`.

```
# docker run -e STORAGEOS_API_ADDR=10.245.103.2:8000 -e STORAGEOS_USER=storageos -e STORAGEOS_PASSWORD=storageos quay.io/storageos/storageos:alpha volume list
ID                                    NAME                       DESCRIPTION  SIZE  DC
7822ede0-d8c8-4c04-eea1-4ecbfb792777  vol-london-mysql-prod                   10
92b987fd-8c6b-2f82-b704-d2f1d6190db0  vol-london-mysql-prod_rep               10
d4815b79-1d92-b5e8-fad0-d91d8df8ee18  redis50                                 10
f5316c79-de20-ba87-4727-a708bd0f53e4  crasher01                               10
```



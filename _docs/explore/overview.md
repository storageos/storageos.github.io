---
layout: guide
title: CLI and UI Overview
anchor: explore
module: explore/overview
---

# Brief Introduction

There are three interfaces into StorageOS.

1. The API, this is the core interface and what everything builds from
2. The CLI, which is run from the hosting OS and provides some basic troubleshooting and diagnostic tools
3. The Web UI, which you can attach to using any StorageOS node IP address

## StorageOS CLI

1.  The StorageOS CLI can be run by directly calling the `storageos` command line utility  or calling its alias, `s`.  Some of the CLI features have been introduced in the installation [Troubleshooting Guide](../install/troubleshoot.html#Troubleshooting Guide) already.

    ```bash
    vagrant@storageos-3:~$ storageos
    Usage: /etc/init.d/storageos {start|stop|restart|reload|update|status|logs|cli|bootstrap|test}
    ```
    --or--
    ```bash
    vagrant@storageos-3:~$ s
    Usage: /etc/init.d/storageos {start|stop|restart|reload|update|status|logs|cli|bootstrap|test}
    ```

2.  To access the CLI functions you need to run `storageos cli`

    ```bash
    vagrant@storageos-3:~$ storageos cli
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

## StorageOS UI

A brief overview on launching and accessing the Web UI has been covered in the previous [Confirming Installation](../install/startwebui.html#Confirming Installation) section already.


---
layout: guide
title: StorageOS Docs - CLI install
anchor: manage
module: manage/cli
---

# Command Line Interface

The `storageos` command line interface is used to manage cluster-wide
configuration. It is open source and available from [Github](https://github.com/storageos/go-cli/releases).

## Installation

```bash
$ sudo -i
$ curl -sSL https://github.com/storageos/go-cli/releases/download/v0.0.4/storageos_linux_amd64 > /usr/local/bin/storageos
$ chmod +x /usr/local/bin/storageos
$ exit
```

On MacOS, replace `storageos_linux_amd64` with `storageos_darwin_amd64`.

## Initial set up

By default StorageOS starts with a single user with username `storageos` and
password `storageos`, so you should set the following environment variables:
```bash
$ export STORAGEOS_USERNAME=storageos STORAGEOS_PASSWORD=storageos
```

To connect to a remote StorageOS cluster:
```bash
$ export STORAGEOS_HOST=127.0.0.1
```

## Further reading

* [CLI reference](../reference/cli.html)
* [Configuration reference](../reference/configuration.html)

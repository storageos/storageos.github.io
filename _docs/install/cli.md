---
layout: guide
title: Consul
anchor: install
module: install/cli
---

# Command line interface

The StorageOS command line interface is used to manage cluster-wide
configuration. It is open source and available from Github. The CLI can connect
remotely to a StorageOS cluster.

On Linux:
```bash
$ curl -sSL https://github.com/storageos/go-cli/releases/download/v0.0.2/storageos_linux_amd64 > storageos
$ chmod +x storageos
```

On MacOS:
```bash
$ curl -sSL https://github.com/storageos/go-cli/releases/download/v0.0.2/storageos_darwin_amd64 > storageos
$ chmod +x storageos
```

[View all supported platforms](https://github.com/storageos/go-cli/releases)

Run `./storageos` to see available commands, or read the [the CLI reference]({{ site.baseurl }}{% link _docs/reference/cli.md %}).

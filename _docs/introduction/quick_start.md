---
layout: guide
title: Quick start
anchor: introduction
module: introduction/quick_start
---

# Quick start

The fastest and easiest way to run StorageOS locally. Tested on Ubuntu 16.04 and MacOS 10.12.

## Install Docker engine

Get the latest version from [docker.com](https://www.docker.com/get-docker).

## Install the volume plugin

```bash
$ sudo mkdir /var/lib/storageos
$ docker plugin install --alias storageos storageos/plugin KV_BACKEND=boltdb
```

## Explore the CLI

```bash
$ storagos --help
$ storageos volume list
```

See [Command line reference]({{ site.baseurl }}{% link _docs/reference/cli.md %}) for available commands.

## Next steps

StorageOS should be installed on a cluster of machines so that data can be replicated across nodes.

## Get a license

To remove the 100GB storage capacity limit on unregistered users, sign up for a free developer license from the [customer portal](http://my.storageos.com).

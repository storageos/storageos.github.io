---
layout: guide
title: Quick start
anchor: introduction
module: introduction/quick_start
---

# Quick start

The fastest and easiest way to get StorageOS running locally. Tested on Ubuntu 16.04 and MacOS 10.12.

## Install Docker engine

Get the latest version from [docker.com](https://www.docker.com/get-docker).

## Install the volume plugin

```bash
$ sudo mkdir /var/lib/storageos
$ docker plugin install --alias storageos storageos/plugin KV_BACKEND=boltdb
```
Note that replication and failover are not available on a single node install.

## Explore the CLI

---
layout: guide
title: StorageOS Docs - Docker volume plugin
anchor: install
module: install/docker/plugin
---

# Docker Managed Plugin (Docker Engine 1.13+)

Use the StorageOS managed plugin to install StorageOS on Docker Engine 1.13+

## Quick Start

```bash
sudo modprobe nbd nbds_max=1024
sudo docker plugin install storageos/plugin
```

## Overview

```bash
$ docker plugin install --alias storageos storageos/plugin
Plugin "storageos/plugin" is requesting the following privileges:
 - network: [host]
 - mount: [/var/lib/storageos]
 - mount: [/dev]
 - device: [/dev/fuse]
 - allow-all-devices: [true]
 - capabilities: [CAP_SYS_ADMIN]
Do you grant the above permissions? [y/N]
```

**NOTE**:  In order to make plugin upgrades easier, install the plugin using
`--alias storageos`.  This ensures that volumes provisioned with a previous
version of the plugin continue to function after the upgrade.  By default,
Docker ties volumes to the plugin version.  Volumes should then be provisioned
using the alias e.g. `--volume-driver storageos`.

If the KV store is not local, supply the IP address of the Consul service using
the `KV_ADDR` parameter:

```bash
docker plugin install --alias storageos storageos/plugin KV_ADDR=127.0.0.1:8500
```

Alternatively, to setup a single test StorageOS instance, you can use the
built-in BoltDB.  Note that each StorageOS node will be isolated, so features
such as replication and volume failover will not be available.

```bash
docker plugin install --alias storageos storageos/plugin KV_BACKEND=boltdb
```

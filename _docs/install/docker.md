---
layout: guide
title: StorageOS Docs - Docker
anchor: install
module: install/docker
---

# Docker Managed Plugin (Docker Engine 1.13+)

Use the StorageOS managed plugin to install StorageOS on Docker Engine 1.13+

## Quick Start

```bash
$ sudo modprobe nbd nbds_max=1024
$ sudo docker plugin install storageos/plugin
```

## Overview

### Requirements

The `docker plugin install` method requires Docker 1.13+ or above.  See
[Docker (1.0 - 1.12)]({% link _docs/install/container.md %}) for the container 
install on previous versions.

### KV Store

StorageOS relies on an external key-value store for configuration data and cluster
management.  See [Key/Value Store]({% link _docs/install/kvstore.md %}) for more details.

### Routable IP Address

StorageOS nodes must be able to contact each other over the network.  By default,
the node's first non-loopback address will be configured as the `ADVERTISE_IP`.
In some cases (such as with Vagrant installations), this will not be appropriate
and it will need to be set manually.

Use `ip a` to list available ip addresses, and then configure StorageOS to use a
specific address by appending `ADVERTISE_IP=<ip>` to the plugin install command:

```
sudo docker plugin install storageos/plugin ADVERTISE_IP=xxx.xxx.xxx.xxx
```

## Installation

NBD (Network Block Device) is a default Linux kernel module that allows block
devices to be run in userspace. It is not a requirement for StorageOS to run,
but improves performance significantly. To enable the module and increase the
number of allowable devices, run:

```bash
$ sudo modprobe nbd nbds_max=1024
```

**To ensure the NBD module is loaded on reboot.**

1. Add the following line to `/etc/modules`
```
nbd
```

2. Add the following module configuration line in `/etc/modprobe.d/nbd.conf`
```
options nbd nbds_max=1024
```

If Consul is running locally, install the plugin using the defaults:

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
$ docker plugin install --alias storageos storageos/plugin KV_ADDR=127.0.0.1:8500
```

Alternatively, to setup a single test StorageOS instance, you can use the
built-in BoltDB.  Note that each StorageOS node will be isolated, so features
such as replication and volume failover will not be available.

```bash
$ docker plugin install --alias storageos storageos/plugin KV_BACKEND=boltdb
```

Other configuration parameters (see [Configuration Reference]({% link _docs/reference/configuration.md %}))
may be set in a similar way.  For most environments, only the KV_ADDR will need
to be set if Consul is not running locally on the node.

---
layout: guide
title: StorageOS Docs - Docker volume plugin
anchor: install
module: install/plugin
---

# Docker Managed Plugin (Docker Engine 1.13+)

Use the StorageOS managed plugin to install StorageOS on Docker Engine 1.13+

## Quick Start

```bash
sudo modprobe nbd nbds_max=1024
sudo docker plugin install storageos/plugin
```

## Overview

### Requirements

The `docker plugin install` method requires Docker 1.13+ or above.  See
[Docker (1.0 - 1.12)]({% link _docs/install/container.md %}) for the container
install on previous versions.

### KV Store

StorageOS relies on an external key-value store for configuration data and
cluster management.  See [Key/Value Store]({% link _docs/install/kvstore.md %})
for more details.

### Routable IP Address

StorageOS nodes must be able to contact each other over the network.  By default,
the node's first non-loopback address will be configured as the `ADVERTISE_IP`.
In some cases (such as with Vagrant installations), this will not be appropriate
and it will need to be set manually.

Use `ip a` to list available ip addresses, and then configure StorageOS to use a
specific address by appending `ADVERTISE_IP=<ip>` to the plugin install command:

```bash
sudo docker plugin install storageos/plugin ADVERTISE_IP=xxx.xxx.xxx.xxx
```

## Installation

NBD (Network Block Device) is a default Linux kernel module that allows block
devices to be run in userspace. It is not a requirement for StorageOS to run,
but improves performance significantly. To enable the module and increase the
number of allowable devices, run:

```bash
sudo modprobe nbd nbds_max=1024
```

**To ensure the NBD module is loaded on reboot.**

1. Add the following line to `/etc/modules`

    ```text
    nbd
    ```

1. Add the following module configuration line in `/etc/modprobe.d/nbd.conf`

    ```text
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
docker plugin install --alias storageos storageos/plugin KV_ADDR=127.0.0.1:8500
```

Alternatively, to setup a single test StorageOS instance, you can use the
built-in BoltDB.  Note that each StorageOS node will be isolated, so features
such as replication and volume failover will not be available.

```bash
docker plugin install --alias storageos storageos/plugin KV_BACKEND=boltdb
```

## Environment variables

For most environments, the default settings should work. If Consul is not
running locally on the node, you will need to set `KV_ADDR`.

* `HOSTNAME`: Hostname of the Docker node, only if you wish to override it.
* `ADVERTISE_IP`: IP address of the Docker node, for incoming connections.  Defaults to first non-loopback address.
* `USERNAME`: Username to authenticate to the API with.  Defaults to `storageos`.
* `PASSWORD`: Password to authenticate to the API with.  Defaults to `storageos`.
* `KV_ADDR`: IP address/port of the Key/Vaue store.  Defaults to `127.0.0.1:8500`
* `KV_BACKEND`: Type of KV store to use.  Defaults to `consul`. `boltdb` can be used for single node testing.
* `API_PORT`: Port for the API to listen on.  Defaults to `5705` ([IANA Registered](https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml?search=5705)).
* `NATS_PORT`: Port for NATS messaging to listen on.  Defaults to `4222`.
* `NATS_CLUSTER_PORT`: Port for the NATS cluster service to listen on.  Defaults to `8222`.
* `SERF_PORT`: Port for the Serf protocol to listen on.  Defaults to `13700`.
* `DFS_PORT`: Port for DirectFS to listen on.  Defaults to `17100`.
* `LOG_LEVEL`: One of `debug`, `info`, `warning` or `error`.  Defaults to `info`.
* `LOG_FORMAT`: Logging output format, one of `text` or `json`.  Defaults to `json`.

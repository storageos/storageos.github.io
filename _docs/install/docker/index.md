---
layout: guide
title: StorageOS Docs - Docker only
anchor: install
# module: install/docker
---

# Overview

For Docker environments, StorageOS can be installed in two ways.

The volume plugin is a convenient package for 1) testing and 2) deploying using Docker Swarm. It's available for Docker engine 1.13 and above.

For Kubernetes users or compatibility with Docker 1.10, use the container install.

In either approach, you will need to install StorageOS on every node in a cluster.

## Prerequisites

### KV Store

StorageOS relies on an external key-value store for configuration data and
cluster management.  See [Key/Value store install]({% link _docs/install/kvstore/index.md %})
for more details.

### NBD

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

### Routable IP Address

StorageOS nodes must be able to contact each other over the network.  By default,
the node's first non-loopback address will be configured as the `ADVERTISE_IP`.
In some cases (such as with Vagrant installations), this will not be appropriate
and it will need to be set manually.

Use `ip a` to list available ip addresses, and then configure StorageOS to use a
specific address by adding `-e ADVERTISE_IP=<ip>` to the StorageOS docker run
command.

# Environment variables

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

---
layout: guide
title: Docker (legacy)
anchor: install
module: install/container
---

# Docker Legacy (Docker Engine 1.10 - 1.12)

Install StorageOS as a container when Docker managed plugins aren't available.

## Quick Start

```bash
$ sudo mkdir /var/lib/storageos
$ wget -O /etc/docker/plugins/storageos.json http://docs.storageos.com/assets/storageos.json
$ docker run -d --name storageos \
	-e HOSTNAME \
	--net=host \
	--pid=host \
	--privileged \
	--cap-add SYS_ADMIN \
	--device /dev/fuse \
	-v /var/lib/storageos:/var/lib/storageos:rshared \
	-v /run/docker/plugins:/run/docker/plugins \
	storageos/storages server
```

## Overview

## Requirements

The container installation method requires Docker 1.10+.  For Docker 1.13+
most users should use the [managed plugin install](docker.html) method.

### KV Store

StorageOS relies on an external key-value store for configuration data and cluster
management.  See [Consul installation](consul.html) for more details.

## Installation

StorageOS shares volumes via the `/var/lib/storageos` directory.  This must be
present on each node where StorageOS runs.  Prior to installation, create it:

```bash
$ sudo mkdir /var/lib/storageos
```

Docker needs to be configured to use the StorageOS volume plugin.  This is done
by writing a configuration file in `/etc/docker/plugins/storageos.json` with
contents:

```json
{
	"Name": "storageos",
	"Addr": "unix:////run/docker/plugins/storageos/storageos.sock"
}
```

This file instructs Docker to use the volume plugin API listening on the
specified Unix domain socket.  Note that the socket is only accessible by the
root user, and it is only present when the StorageOS client container is running.  

If Consul is running locally, install the plugin using the defaults:

```bash
$ docker run -d --name storageos \
	-e HOSTNAME \
	--net=host \
	--pid=host \
	--privileged \
	--cap-add SYS_ADMIN \
	--device /dev/fuse \
	-v /var/lib/storageos:/var/lib/storageos:rshared \
	-v /run/docker/plugins:/run/docker/plugins \
	storageos/storages server
```

If the KV store is not local, supply the IP address of the Consul service using
the `KV_ADDR` environment variable:

```bash
$ docker run -d --name storageos \
	-e HOSTNAME \
  -e KV_ADDR=127.0.0.1:8500 \
	--net=host \
	--pid=host \
	--privileged \
	--cap-add SYS_ADMIN \
	--device /dev/fuse \
	-v /var/lib/storageos:/var/lib/storageos:rshared \
	-v /run/docker/plugins:/run/docker/plugins \
	storageos/storages server
$ docker plugin install storageos/plugin KV_ADDR=127.0.0.1:8500
```

Alternatively, to setup a single test StorageOS instance, you can use the
built-in BoltDB by setting `KV_BACKEND=boltdb`.  Note that each StorageOS node
will be isolated, so features such as replication and volume failover will not
be available.

Other configuration parameters (see [Configuration Reference](../reference/configuration.html))
may be set in a similar way.  For most environments, only the KV_ADDR will need
to be set if Consul is not running locally on the node.

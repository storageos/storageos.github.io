---
layout: guide
title: Docker (advanced)
anchor: install
module: install/advanced
---

# Docker Advanced Installation

If you require greater control, StorageOS can be deployed in other ways.

## Overview

By default, StorageOS provides all of its services from a single container.  It
is also possible to split services into multiple container instances.

This allows some critical components which are updated infrequently to remain
running while other components are being upgraded.  Our aim is to reduce and
eventually eliminate any loss of service during an upgrade.

StorageOS currently supports running the Control Plane and Data Plane in
separate containers.  We expect the Data Plane to stabilise over time and to
require fewer updates than the Control Plane.

## Requirements

The split-container installation method works on Docker 1.10+.  It is not
compatible with Docker managed plugins, which are limited to a single container.

Docker Compose is recommended.

### KV Store

StorageOS relies on an external key-value store for configuration data and cluster
management.  See [Consul installation](consul.html) for more details.

## Installation

### Manual Installation

StorageOS shares volumes via the `/var/lib/storageos` directory.  This must be
present on each node where StorageOS runs.  Prior to installation, create it:

```bash
$ sudo mkdir /var/lib/storageos
```

Run the Control Plane container:

```bash
$ docker run -d --name controlplane \
	-e HOSTNAME \
	--net=host \
	--pid=host \
	--privileged \
	--cap-add SYS_ADMIN \
	-v /var/lib/storageos:/var/lib/storageos:rshared \
	-v /run/docker/plugins:/run/docker/plugins \
	storageos/storages controlplane
```

Run the Data Plane container:

```bash
$ docker run -d --name dataplane \
	-e HOSTNAME \
	--net=host \
	--pid=host \
	--privileged \
	--cap-add SYS_ADMIN \
	--device /dev/fuse \
	-v /var/lib/storageos:/var/lib/storageos:rshared \
	storageos/storages dataplane
```

Environment variables (described below) be added to tune configuration.

### Docker Compose

Docker Compose can be used to start separate Control Plane and Data Plane
containers.

Write the compose file (below) to a file, e.g. `/etc/storageos/docker-compose.yml`.

```yaml
version: '2'
services:
  control:
    image: storageos/storageos:beta
    command: "controlplane"
    restart: always
    environment:
      - HOSTNAME
    privileged: true
    cap_add:
      - "SYS_ADMIN"
    env_file: /etc/default/storageos
    ports:
      - "5705:5705"
      - "4222:4222"
      - "8222:8222"
      - "13700:13700/tcp"
      - "13700:13700/udp"
    volumes:
      - "/var/lib/storageos:/var/lib/storageos:rshared"
      - "/run/docker/plugins:/run/docker/plugins"
  data:
    image: storageos/storageos:beta
    command: "dataplane"
    restart: always
    env_file: /etc/default/storageos
    network_mode: host
    privileged: true
    cap_add:
      - "SYS_ADMIN"
    pid: host
    environment:
      - HOSTNAME
    devices:
      - /dev/fuse
    volumes:
      - "/var/lib/storageos:/var/lib/storageos:rshared"
    ports:
      - "8999:8999"
```

Environment variables (see [Configuration Reference](../reference/configuration.html)) can be added to tune configuration.

Start the containers with:

```bash
$ docker compose -f /etc/storageos/docker-compose.yml up
```

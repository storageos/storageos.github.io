---
layout: guide
title: StorageOS Docs - Docker volume plugin
anchor: install
module: install/docker/plugin
---

# Docker Managed Plugin

Install the StorageOS volume plugin on Docker Engine 1.13+.

>**Use the [container install method]({%link _docs/install/docker/container.md %}) with Kubernetes or to mount volumes to the host using the CLI.**

## Prerequisites

[Enable nbd:]({%link _docs/install/prerequisites/nbd.md %})
```bash
sudo modprobe nbd nbds_max=1024
```

## Install the volume plugin

In order to make plugin upgrades easier, install the plugin using
`--alias storageos`.  This ensures that volumes provisioned with a previous
version of the plugin continue to function after the upgrade.  (By default,
Docker ties volumes to the plugin version.)

Provide the host ip address in `ADVERTISE_IP` and a [cluster discovery
token]({%link _docs/install/prerequisites/clusterdiscovery.md %}) with
`JOIN` when you install the container:

```bash
$ docker plugin install --alias storageos storageos/plugin ADVERTISE_IP=xxx.xxx.xxx.xxx JOIN=xxxxxxxxxxxxxxxxx
Plugin "storageos/plugin" is requesting the following privileges:
 - network: [host]
 - mount: [/var/lib]
 - mount: [/dev]
 - device: [/dev/fuse]
 - allow-all-devices: [true]
 - capabilities: [CAP_SYS_ADMIN]
Do you grant the above permissions? [y/N]
```

To use StorageOS volumes with containers, specify `--volume-driver storageos`:

```bash
$ docker container run -it --volume-driver storageos --volume myvol:/data busybox sh
/ #
```
This creates a new container with a StorageOS volume called `myvol` mounted at `/data`.

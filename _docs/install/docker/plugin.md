---
layout: guide
title: StorageOS Docs - Docker volume plugin
anchor: install
module: install/docker/plugin
---

# Docker Managed Plugin

Install the StorageOS volume plugin on Docker Engine 1.13+.

>**This method is due to be deprecated; use the [Kubernetes install]({%link _docs/install/kubernetes/index.md %}) or [container install method]({%link _docs/install/docker/index.md %}) method instead.**

## Prerequisites

[Enable nbd:]({%link _docs/install/prerequisites/devicepresentation.md %})
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
$ docker plugin install --alias storageos storageos/plugin:0.9.2 ADVERTISE_IP=xxx.xxx.xxx.xxx JOIN=xxxxxxxxxxxxxxxxx
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
# Create a new container with a StorageOS volume called `myvol` mounted at `/data`
$ docker container run -it --volume-driver storageos --volume myvol:/data busybox sh
/ #
```

Logs are available via `journalctl`.

```bash
$ journalctl -u docker | grep StorageOS
Aug 11 15:27:06 storageos-1 dockerd[14521]: time="2017-08-11T15:27:06Z" level=info msg="By using this product, you are agreeing to the terms of the StorageOS Ltd. End User Subscription Agreement (EUSA) found at: https://storageos.com/legal/#eusa" plugin=8faec9ebb155cb05a42ac804bb21a0cfb1c0861543fa2741fd04e8ce0acc421a
Aug 11 15:27:06 storageos-1 dockerd[14521]: time="2017-08-11T15:27:06Z" level=info msg="==> Starting StorageOS server..." plugin=8faec9ebb155cb05a42ac804bb21a0cfb1c0861543fa2741fd04e8ce0acc421a
Aug 11 15:27:12 storageos-1 dockerd[14521]: time="2017-08-11T15:27:12Z" level=info msg="    version: StorageOS c456268, Built: 2017-08-10T105011Z" plugin=8faec9ebb155cb05a42ac804bb21a0cfb1c0861543fa2741fd04e8ce0acc421a
Aug 11 15:27:15 storageos-1 dockerd[14521]: time="2017-08-11T15:27:15Z" level=info msg="==> StorageOS server running!" plugin=8faec9ebb155cb05a42ac804bb21a0cfb1c0861543fa2741fd04e8ce0acc421a
Aug 11 15:27:15 storageos-1 dockerd[14521]: time="2017-08-11T15:27:15Z" level=info msg="StorageOS Volume Presentation level=info" plugin=8faec9ebb155cb05a42ac804bb21a0cfb1c0861543fa2741fd04e8ce0acc421a
Aug 11 15:27:15 storageos-1 dockerd[14521]: time="2017-08-11T15:27:15Z" level=info msg="StorageOS DirectFS v1 server (server v0.1 protocol v1.2) start level=info" plugin=8faec9ebb155cb05a42ac804bb21a0cfb1c0861543fa2741fd04e8ce0acc421a
Aug 11 15:27:16 storageos-1 dockerd[14521]: time="2017-08-11T15:27:16Z" level=info msg="StorageOS DIRECTOR category=director level=info" plugin=8faec9ebb155cb05a42ac804bb21a0cfb1c0861543fa2741fd04e8ce0acc421a
Aug 11 15:27:16 storageos-1 dockerd[14521]: time="2017-08-11T15:27:16Z" level=info msg="StorageOS DirectFS v1 client (server v0.1 protocol v1.2) start category=clinit level=info" plugin=8faec9ebb155cb05a42ac804bb21a0cfb1c0861543fa2741fd04e8ce0acc421a
Aug 11 15:27:17 storageos-1 dockerd[14521]: time="2017-08-11T15:27:17Z" level=info msg="StorageOS RDB plugin category=rdbplginit level=info" plugin=8faec9ebb155cb05a42ac804bb21a0cfb1c0861543fa2741fd04e8ce0acc421a
```

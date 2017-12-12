---
layout: guide
title: StorageOS Docs - Docker container
anchor: install
module: install/docker/container
---

# Docker Application Container

Install StorageOS as an application container for Docker Engine 1.10+ or
Kubernetes 1.7+.

## Prerequisites

[Enable nbd:]({%link _docs/install/prerequisites/devicepresentation.md %})
```bash
sudo modprobe nbd nbds_max=1024
```

## Install the storageos/node container

Provide the host ip address in `ADVERTISE_IP` and a [cluster discovery
token]({%link _docs/install/prerequisites/clusterdiscovery.md %}) with
`JOIN` when you install the container:

```bash
docker run -d --name storageos \
    -e HOSTNAME \
    -e ADVERTISE_IP=xxx.xxx.xxx.xxx \
    -e JOIN=xxxxxxxxxxxxxxxxx \
    --net=host \
    --pid=host \
    --privileged \
    --cap-add SYS_ADMIN \
    --device /dev/fuse \
    -v /var/lib/storageos:/var/lib/storageos:rshared \
    -v /run/docker/plugins:/run/docker/plugins \
    storageos/node:0.9.0 server
```

To use StorageOS volumes with containers, specify `--volume-driver storageos`:

```bash
$ docker container run -it --volume-driver storageos --volume myvol:/data busybox sh
/ #
```
This creates a new container with a StorageOS volume called `myvol` mounted at `/data`.

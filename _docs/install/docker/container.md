---
layout: guide
title: StorageOS Docs - Docker container
anchor: install
module: install/docker/container
---

# Docker Application Container

Install StorageOS as an application container for Docker Engine 1.10+ or Kubernetes 1.7+.

## Prerequisites

[Enable nbd:]({%link _docs/install/prerequisites/nbd.md %})
```bash
sudo modprobe nbd nbds_max=1024
```

StorageOS shares volumes via `/var/lib/storageos`.  This must be
present on each node where StorageOS runs.

```bash
sudo mkdir /var/lib/storageos
```

For Docker only or Docker Swarm clusters, configure Docker to use the StorageOS
volume plugin:

```bash
sudo wget -O /etc/docker/plugins/storageos.json https://docs.storageos.com/assets/storageos.json
```

## Install the storageos/node container

Provide the host ip address in `ADVERTISE_IP` and a [cluster discovery
token]({%link _docs/install/prerequisites/clusterdiscovery.md %}) with
`CLUSTER_ID` when you install the container:

```bash
docker run -d --name storageos \
    -e HOSTNAME \
    -e ADVERTISE_IP=xxx.xxx.xxx.xxx \
    -e CLUSTER_ID=xxxxxxxxxxxxxxxxx \
    --net=host \
    --pid=host \
    --privileged \
    --cap-add SYS_ADMIN \
    --device /dev/fuse \
    -v /var/lib/storageos:/var/lib/storageos:rshared \
    -v /run/docker/plugins:/run/docker/plugins \
    storageos/node server
```

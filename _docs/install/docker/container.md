---
layout: guide
title: StorageOS Docs - Docker container
anchor: install
module: install/docker/container
---

# Docker Application Container

Install StorageOS as an application container for Docker Engine 1.10+ or Kubernetes 1.7+.

## Prerequisites

Ensure you have a functioning [key-value store and NBD is enabled]({%link _docs/install/prerequisites/index.md %}).

StorageOS shares volumes via `/var/lib/storageos`.  This must be
present on each node where StorageOS runs.

```bash
sudo mkdir /var/lib/storageos
```

For Docker only or Docker Swarm clusters, Docker needs to be configured to use
the StorageOS volume plugin:

```bash
sudo wget -O /etc/docker/plugins/storageos.json https://docs.storageos.com/assets/storageos.json
```

## Install the storageos/node container

```bash
docker run -d --name storageos \
    -e HOSTNAME \
    -e ADVERTISE_IP=xxx.xxx.xxx.xxx \
    --net=host \
    --pid=host \
    --privileged \
    --cap-add SYS_ADMIN \
    --device /dev/fuse \
    -v /var/lib/storageos:/var/lib/storageos:rshared \
    -v /run/docker/plugins:/run/docker/plugins \
    storageos/node server
```

If the KV store is not local, supply the IP address of the Consul service using
the `KV_ADDR` environment variable.

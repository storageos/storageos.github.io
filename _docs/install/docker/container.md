---
layout: guide
title: StorageOS Docs - Docker container
anchor: install
module: install/docker/container
---

# Docker Application Container

Install StorageOS as an application container for Docker Engine 1.10+ or Kubernetes 1.7+.

```bash
sudo mkdir /var/lib/storageos
sudo wget -O /etc/docker/plugins/storageos.json https://docs.storageos.com/assets/storageos.json
sudo modprobe nbd nbds_max=1024
docker run -d --name storageos \
    -e HOSTNAME \
    --net=host \
    --pid=host \
    --privileged \
    --cap-add SYS_ADMIN \
    --device /dev/fuse \
    -v /var/lib/storageos:/var/lib/storageos:rshared \
    -v /run/docker/plugins:/run/docker/plugins \
    storageos/node server
```

### Prerequisites

Ensure you have a functioning [key-value store and NBD is enabled]({%link _docs/install/docker/index.md %}).

If the KV store is not local, supply the IP address of the Consul service using
the `KV_ADDR` environment variable:

```bash
docker run -d --name storageos \
    -e HOSTNAME \
    -e KV_ADDR=127.0.0.1:8500 \
    --net=host \
    --pid=host \
    --privileged \
    --cap-add SYS_ADMIN \
    --device /dev/fuse \
    -v /var/lib/storageos:/var/lib/storageos:rshared \
    -v /run/docker/plugins:/run/docker/plugins \
    storageos/node server

docker plugin install storageos/plugin KV_ADDR=127.0.0.1:8500
```

Alternatively, to setup a single test StorageOS instance, you can use the
built-in BoltDB by setting `KV_BACKEND=boltdb`.  Note that each StorageOS node
will be isolated, so features such as replication and volume failover will not
be available.

### Shared volume directory

StorageOS shares volumes via `/var/lib/storageos`.  This must be
present on each node where StorageOS runs.  Prior to installation, create it:

```bash
sudo mkdir /var/lib/storageos
```

### Docker only/Docker Swarm configuration

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

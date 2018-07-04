---
layout: guide
title: StorageOS Docs - Maintenance
anchor: operations
module: operations/maintenance
---

# Maintenance

## Add a node

Nodes may be added to a cluster by running the StorageOS container with `JOIN`
set to the IP address of one of the nodes.

## Upgrade a node

### 1. Drain volumes from the node

```bash
$ storageos node drain node01
```

This evicts any active volumes as follows:

1. If there are no replicas, create a new replica.
2. Promote a replica to master.
3. Switch the original master to become a replica.
4. Relocate the original master to a different node (or remove it if a new replica was created in step 1).

If StorageOS cannot create a replica in step 1 (eg. because there are no
available nodes or because placement is restricted by a node selector or rule),
the original master volume will remain in the drained node. When a new eligible
node is added to the cluster, the volume will be moved automatically.

This operation will take longer for large volumes.

Draining a node will not cause downtime. Any volume mounted in that
specific node will be evicted but still hold the StorageOS mount, making the
data transparently available to the client.

Finally, draining nodes will also prevent new volumes from being scheduled to the
node (as with `storageos node cordon`).

### 2. Kill the container

```bash
docker kill storageos
```

### 3. Restart the StorageOS node container with the new version

```bash
docker run -d --name storageos \
    -e HOSTNAME \
    -e ADVERTISE_IP=10.26.2.5 \
    -e JOIN=017e4605-3c3a-434d-b4b1-dfe514a9cd0f \
    --pid=host \
    --network=host \
    --privileged \
    --cap-add SYS_ADMIN \
    --device /dev/fuse \
    -v /sys:/sys \
    -v /var/lib/storageos:/var/lib/storageos:rshared \
    -v /run/docker/plugins:/run/docker/plugins \
    storageos/node:1.0.0-rc2 server
```

See

### 4. Undrain the node

```bash
$ storageos node undrain node01
```

## Removing nodes

It is currently not possible for a node to leave the cluster completely. If the
StorageOS container is stopped and/or removed from a node then the node will be
detected as failed and it will be marked offline, but there is no way to remove
the node from the list. `storageos node rm` will be added to remove the node
from the cluster.

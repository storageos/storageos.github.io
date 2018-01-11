---
layout: guide
title: StorageOS Docs - Cluster discovery
anchor: install
module: install/prerequisites/clusterdiscovery
---

# Cluster discovery

On startup, you will need to specify whether a StorageOS node should bootstrap a
new cluster or join an existing cluster.

## Setting the IP address

By default, a node's IP address is assumed to be the first non-loopback address.
To override this, set the `ADVERTISE_IP` environment variable on each node:

```bash
ADVERTISE_IP=172.28.128.3
```

## Cluster initialization

StorageOS offers a public `etcd` discovery service, which is a convenient way to
pass clustering information to the StorageOS node.

```bash
# Create a cluster discovery token. This token is not used after initialization
storageos cluster create
017e4605-3c3a-434d-b4b1-dfe514a9cd0f

# Supply the returned cluster ID token to each node via JOIN
JOIN=017e4605-3c3a-434d-b4b1-dfe514a9cd0f
```

Alternatively, you can specify the IP addresses explicity.

```bash
# Specify a node to connect to in an existing cluster
JOIN=172.28.128.3

# Specify a list of nodes to attempt to connect to, in left-to-right order
JOIN=172.28.128.3,172.28.128.9,172.28.128.15

# Specify both the discovery service and IP addresses, tried left-to-right
JOIN=d53e9fae-7436-4185-82ea-c0446a52e2cd,172.28.128.3,172.28.128.9
```

You can [check the cluster status]({%link _docs/install/health.md %}) to confirm
a successful installation.

### Single node clusters

The `JOIN` command line argument is always required, even in clusters with only
one node. A blank `JOIN` variable will result in a non-functional cluster. This
is to prevent non-obvious split-brain scenarios in multi-node clusters, where
`JOIN` was mistakenly omitted.

```bash
# Create a one-node cluster
JOIN=$ADVERTISE_IP
```

Replicas are unavailable in a single node install.

## Node failure tolerance

StorageOS embeds a key-value store called etcd in clusters with at least three
nodes for failover. The default three etcd nodes allows for a single node
failure, which can be increased to achieve greater tolerance.

```bash
# Tolerate up to two node failures
storageos cluster create --size 5

# Tolerate up to three node failures
storageos cluster create --size 7
```

Performance will degrade for more than seven etcd nodes.

This does not affect how many StorageOS nodes can join the cluster.

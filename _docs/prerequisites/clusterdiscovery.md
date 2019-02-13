---
layout: guide
title: StorageOS Docs - Cluster discovery
anchor: prerequisites
module: prerequisites/clusterdiscovery
---

# Cluster discovery

On startup, you will need to specify whether a StorageOS node should bootstrap
a new cluster or join an existing cluster. In order for a bootstrapping node to
join or create a cluster, the node needs to know where to find the other nodes
in the cluster. The node is informed of other nodes in the cluster via the JOIN
variable.

> N.B. The StorageOS operator will automatically populate the JOIN variable.
> Manual population of the JOIN variable, with node IPs or a cluster token, is
> possible if necessary.

## Cluster initialization

StorageOS offers a public discovery service, which is a convenient way to
pass clustering information to the StorageOS node.

```bash
# Create a cluster discovery token. This token is not used after initialization
$ storageos cluster create
017e4605-3c3a-434d-b4b1-dfe514a9cd0f

# Add the returned cluster ID token to the JOIN variable
JOIN=017e4605-3c3a-434d-b4b1-dfe514a9cd0f
```

Alternatively, you can specify the IP addresses of nodes to join. If you
provide a list of node IPs any new node joining the cluster will attempt to
contact the node IPs specified. This means that if all the nodes in the JOIN
are unavailable that new nodes will be unable to join the cluster.

```bash
# Specify a node to connect to in an existing cluster
JOIN=172.28.128.3

# Specify a list of nodes to attempt to connect to, in left-to-right order
JOIN=172.28.128.3,172.28.128.9,172.28.128.15

# Specify both the discovery service and IP addresses, tried left-to-right
JOIN=d53e9fae-7436-4185-82ea-c0446a52e2cd,172.28.128.3,172.28.128.9
```

The `JOIN` command line argument is always required, even in clusters with only
one node. A blank `JOIN` variable will result in a non-functional cluster. This
is to prevent non-obvious split-brain scenarios in multi-node clusters, where
`JOIN` was mistakenly omitted.

```bash
# Create a one-node cluster; note that replicas are unavailable.
JOIN=$ADVERTISE_IP
```

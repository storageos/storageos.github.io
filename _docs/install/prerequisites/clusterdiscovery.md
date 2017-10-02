---
layout: guide
title: StorageOS Docs - Cluster discovery
anchor: install
module: install/prerequisites/clusterdiscovery
---

# Cluster discovery

StorageOS nodes need to be informed which cluster to join on start-up. This enables
the nodes to contact each-other over the network to join a pre-existing cluster,
or bootstrap a new one.

## Setting the IP address

By default, a node's IP address is assumed to be the first non-loopback address.
To override this (e.g. for Vagrant installations), set the `ADVERTISE_IP`
environment variable on each node to configure StorageOS to use a specific
address:

```bash
ADVERTISE_IP=172.28.128.3
```

## Clustering

The Raft protocol requires an odd number of nodes for consensus. The recommended size
for test and small production deployments is 3 nodes, which can tolerate a
single node failure. Greater tolerance can be achieved with 5 or 7 node
clusters; performance will degrade for more nodes.

Replicas are unavailable in a single node install.

## The `JOIN` keyword

The environment variable `JOIN` is used to pass clustering information to the StorageOS node.
This environment variable can contain two types of information, a cluster token or a set of IP addresses.

### Option 1: Cluster token

StorageOS offers a public `etcd` discovery service to aid in cluster discovery.

To use this method, specify the expected size of the cluster (3 ,5 or 7) using the [StorageOS CLI]({%link
_docs/reference/cli/cluster.md %}):

```bash
$ storageos cluster create --size 3
017e4605-3c3a-434d-b4b1-dfe514a9cd0f
```

Supply the returned cluster ID token as an environment variable to each node:

```bash
JOIN=017e4605-3c3a-434d-b4b1-dfe514a9cd0f
```

Each node will report that it is waiting for the cluster. Once three members
are registered, StorageOS will start up.


### Option 2: Specifying IP addresses

An alternative to the discovery service is providing an explicit list of IP addresses.

```bash
JOIN=storageos-1=172.28.128.3,172.28.128.9,172.28.128.15
```

### Option 3: Doing both

These methods are not mutually exclusive, and in some situations it may be desirable to use both.

```bash
JOIN=d53e9fae-7436-4185-82ea-c0446a52e2cd,172.28.128.3,172.28.128.9
```

* [Checking the cluster status]({%link _docs/install/health.md %})

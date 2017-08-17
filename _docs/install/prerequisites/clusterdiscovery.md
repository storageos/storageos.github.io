---
layout: guide
title: StorageOS Docs - Cluster discovery
anchor: install
module: install/prerequisites/clusterdiscovery
---

# Cluster discovery

StorageOS nodes need to know the exact cluster size and peers to connect to
during start up. This enables nodes to contact each other over the network.

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

### Option 1: Specify cluster size

The first option is to use the StorageOS discovery service, which is a public `etcd` service.

Specify the expected size of the cluster (3 ,5 or 7) using the [StorageOS CLI]({%link
_docs/reference/cli/cluster.md %}):

```bash
$ storageos cluster create --size 3
017e4605-3c3a-434d-b4b1-dfe514a9cd0f
```

Supply the returned cluster ID token as an environment variable to each node:

```bash
CLUSTER_ID=017e4605-3c3a-434d-b4b1-dfe514a9cd0f
```

Each node will report that it is waiting for the cluster. Once three members
are registered, StorageOS will start up.


### Option 2: Specify hostnames and IP addresses

Alternatively, provide an explicit list of hostnames and IP addresses via the
`INITIAL_CLUSTER` environment variable.

```bash
INITIAL_CLUSTER=storageos-1=http://172.28.128.3:2380,storageos-2=http://172.28.128.9:2380,storageos-3=http://172.28.128.15:2380
```

* [Checking the cluster status]({%link _docs/install/health.md %})

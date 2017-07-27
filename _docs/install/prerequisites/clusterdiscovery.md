---
layout: guide
title: StorageOS Docs - Cluster discovery
anchor: install
module: install/prerequisites/clusterdiscovery
---

# Cluster discovery

StorageOS nodes must be able to contact each other over the network.  By default, it is assumed that this is the node's first non-loopback address.

## Setting the IP address manually

In some cases (such as with Vagrant installations), this will not be appropriate and it will need to be set manually.

Use `ip a` to list available ip addresses, then set the `ADVERTISE_IP` environment variable on each node to configure StorageOS to use a
specific address:

```bash
export ADVERTISE_IP=172.28.128.3
```

To view the status of a cluster, run `storageos node ls`:

```bash
$ storageos node ls

NAME                  ADDRESS             HEALTH              SCHEDULER           VOLUMES             TOTAL               USED                VERSION             LABELS
vol-test-2gb-lon101   46.101.50.155       Healthy 2 days      true                M: 0, R: 2          77.43GiB            5.66%               0.7 (00ab7b3 rev)
vol-test-2gb-lon102   46.101.50.231       Healthy 2 days      false               M: 1, R: 0          38.71GiB            5.90%               0.7 (00ab7b3 rev)
vol-test-2gb-lon103   46.101.51.16        Healthy 2 days      false               M: 1, R: 1          77.43GiB            5.61%               0.7 (00ab7b3 rev)
```

<!--
A StorageOS cluster needs to know the exact cluster size and peers to connect to
during start up.


## Cluster discovery

The StorageOS discovery service makes it easy to form a cluster using a token, which is supplied to each node. This is available through the [StorageOS CLI](link /_docs/reference/cli).

To get a token:
```bash
$ storageos cluster create
cluster token: 017e4605-3c3a-434d-b4b1-dfe514a9cd0f
```

Supply this cluster ID to all the nodes that you want to join the cluster:
```bash
CLUSTER_ID=017e4605-3c3a-434d-b4b1-dfe514a9cd0f
```

Each node will report that it is waiting for the cluster. Once enough members
are registered, StorageOS will start up.

Alternatively, you can supply the `INITIAL_CLUSTER` environment variable:

```bash
INITIAL_CLUSTER=storageos-1=http://172.28.128.3:2380,storageos-2=http://172.28.128.9:2380,storageos-3=http://172.28.128.15:2380
```
-->

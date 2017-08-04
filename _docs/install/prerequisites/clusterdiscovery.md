---
layout: guide
title: StorageOS Docs - Cluster discovery
anchor: install
module: install/prerequisites/clusterdiscovery
---

# Cluster discovery

A StorageOS cluster needs to know the exact cluster size and peers to connect to
during start up. This enables nodes to contact each other over the network.

## Setting the IP address

By default, a node's IP address is assumed to be the first non-loopback address.
To override this (eg. for Vagrant installations), set the `ADVERTISE_IP`
environment variable on each node to configure StorageOS to use a specific
address:

```bash
ADVERTISE_IP=172.28.128.3
```

## Option 1: Cluster discovery service

The simplest method is to use the discovery service, which is available through
the [StorageOS CLI]({%link _docs/reference/cli/cluster.md %}). To get a token
for a cluster with three nodes:

```bash
$ storageos cluster create --size 3
cluster token: 017e4605-3c3a-434d-b4b1-dfe514a9cd0f
```

Supply this cluster ID to all the nodes that you want to join the cluster:
```bash
CLUSTER_ID=017e4605-3c3a-434d-b4b1-dfe514a9cd0f
```

Each node will report that it is waiting for the cluster. Once three members
are registered, StorageOS will start up.


## Option 2: Supply INITIAL_CLUSTER

Alternatively, provide an explicit list of hostnames and IP addresses via the `INITIAL_CLUSTER` environment variable.
```bash
INITIAL_CLUSTER=storageos-1=http://172.28.128.3:2380,storageos-2=http://172.28.128.9:2380,storageos-3=http://172.28.128.15:2380
```

For development purposes you can also spin up a single node cluster:
```bash
INITIAL_CLUSTER=storageos-1=http://172.28.128.3:2380
```
Note that replicas are not available in a single node install.

## Check cluster status

To check the cluster initialized successfully, run

```bash
$ storageos node ls

NAME                  ADDRESS             HEALTH              SCHEDULER           VOLUMES             TOTAL               USED                VERSION             LABELS
vol-test-2gb-lon101   46.101.50.155       Healthy 2 days      true                M: 0, R: 2          77.43GiB            5.66%               0.7 (00ab7b3 rev)
vol-test-2gb-lon102   46.101.50.231       Healthy 2 days      false               M: 1, R: 0          38.71GiB            5.90%               0.7 (00ab7b3 rev)
vol-test-2gb-lon103   46.101.51.16        Healthy 2 days      false               M: 1, R: 1          77.43GiB            5.61%               0.7 (00ab7b3 rev)
```

---
layout: guide
title: StorageOS Docs - Replication
anchor: manage
module: manage/features/replication
---

# Replication

Replication is used for data protection and failover. Writes to the master volume are written synchronously to replicas, which are on scheduled on different nodes. Therefore the maximum number of replicas is the number of nodes - 1.

If the master volume is lost, a random replica is promoted to master.

If a replica volume is lost and there are enough remaining nodes, a new replica is created and synced.

## Create a replicated volume

To create a replicated volume, specify the number of desired replicas with the
`storageos.feature.replicas` label.

To create a volume with 2 replicas (3 copies of the data total), set the `storageos.feature.replicas` label with the StorageOS CLI:

```bash
storageos volume create --namespace default --label storageos.feature.replicas=2 volume-name
```

or the Docker CLI:

```bash
$ docker volume create --driver storageos --opt size=15 --opt storageos.feature.replicas=2 volume-name
volume-name
```

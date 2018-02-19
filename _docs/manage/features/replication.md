---
layout: guide
title: StorageOS Docs - Replication
anchor: manage
module: manage/features/replication
---

# Replication

Replication is used for data protection, high availability and failover.

If a volume is replicated, each replica is scheduled on a different node. Writes
to the master volume are written synchronously to each replica. During the
replication process a volume can continue to be used with no noticeable drop in
performance.

The maximum number of replicas that can be created is five, or up to the number
of remaining nodes in the cluster. For most applications, one replica is
sufficient.

## Recovery

If the master volume is lost, a random replica is promoted to master and a new
replica is created and synced.

If a replica volume is lost and there are enough remaining nodes, a new replica
is created and synced.

###  Create a volume with replicas

Volumes are replicated (copied) across nodes by setting the StorageOS feature
label `storageos.com/replicas` to a value between 1 and 5. No
replicas are set by default.

To create a volume with 2 replicas (3 copies of the data total), set the
`storageos.com/replicas` label:

```bash
storageos volume create --namespace default --label storageos.com/replicas=2 volume-name
```

or the Docker CLI:

```bash
$ docker volume create --driver storageos --opt size=15 --opt storageos.com/replicas=2 volume-name
volume-name
```

### Adding replicas

When `storageos.com/replicas` is set on an existing volume, the entire
volume will be copied (synced via a separate process) to a new replica, and any
new writes that come in to the master volume during or after the sync will also
be copied.

To add replicas to a volume:
```bash
$ storageos volume update --label-add storageos.com/replicas=2 default/volume-name
```

---
layout: guide
title: StorageOS Docs - Replication
anchor: manage
module: manage/features/high-availability
---

# High Availability

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

While a new replica is created and being synced, the volume's health will be
marked as `degraded` and the failure mode will determine whether the volume can
be used while the recovery is taking place.

### Create a volume with replicas

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
storageos volume update --label-add storageos.feature.replicas=2 default/volume-name
```

## Failure modes

Failure modes specify how StorageOS should react to node issues.

There are three different modes:

* *soft* is the default mode.  It works together with the failure tolerance
  label to help decide whether the volume should be writable or not.  The
  failure tolerance specifies how many failed replicas we tolerate, defaulting
  to 1 if there is only 1 replica, or replicas - 1 if there is more than 1
  replica.

  To ensure there are always two copies of the data, use `hard` mode with a
  single replica, or use two replicas with `soft` mode.

* *hard*: if the number of replicas falls below that set in
  `storageos.com/replicas`, mark the volume as unavailable. Any reads or writes
  will fail.

* *alwayson*: as long as any copy of the volume is available, the volume will be
  usable.

You can select failure mode using labels:

```bash
storageos volume create --namespace default --label storageos.com/replicas=2 --label storageos.com/failure.mode=alwayson volume-name
```

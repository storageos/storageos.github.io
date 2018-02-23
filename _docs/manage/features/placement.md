---
layout: guide
title: StorageOS Docs - Volume placement
anchor: manage
module: manage/features/placement
---

# Volume Placement

Master volume placement can be influenced when the volume created by specifying the requested master node name in the
`storageos.com/hint.master` label.  When possible, the scheduler will place the master volume on this node.  If this is not
possible, perhaps due insufficient capacity on the requested node, the scheduler evaluate remaining nodes and place the
volume elsewhere.

The Docker Volume Plugin will set `storageos.com/hint.master` to the node requesting the volume, so that by default the
master will be on the same node as the container that creates it.

## Get a list of StorageOS nodes

Get a list of available nodes:

```bash
$ storageos node ls -q
storageos-1-88252
storageos-2-88252
storageos-3-88252
```

## Create a volume with master on a specific node

Set the `storageos.com/hint.master` label to the requested node:

```bash
storageos volume create --namespace default --label storageos.com/hint.master=storageos-3-88252 volume-name
```

or the Docker CLI:

```bash
$ docker volume create --driver storageos --opt size=15 --opt storageos.com/hint.master=storageos-3-88252 volume-name
volume-name
```

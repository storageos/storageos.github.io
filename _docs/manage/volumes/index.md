---
layout: guide
title: StorageOS Docs - Volumes
anchor: manage
module: manage/volumes/index
# Last reviewed by cheryl.hung@storageos.com on 2017-04-13
---

# Volumes

Volumes are used to store data.

Volumes are provisioned from [storage pools](#pools). All volumes are thinly provisioned
so only consume capacity which is actually used.

In order to mount volumes into containers, they are formatted with a filesystem
such as `ext4`. All volumes accessible to any container anywhere on the cluster
(global namespace) but each volume may only be mounted by one container at a
time.

You can manage volumes within your organization using [namespaces](#namespaces)
and [labels]({% link _docs/manage/volumes/labels.md %}).

StorageOS volumes may be accessed through the [standard Docker
CLI](https://docs.docker.com/engine/reference/commandline/volume_create/), or
through the [storageos CLI]({% link _docs/manage/volumes/create.md %}) for more
options and control.

# Namespaces

Namespaces help different projects or teams share a StorageOS cluster. No
namespaces are created by default, and users can have any number of namespaces.

Namespaces apply to volumes and rules.

>**Note**: Docker does not support namespaces, so you should avoid mixing
volumes created by `docker volume create` (which does not allow namespaces) with
volumes created by `storageos volume create` (which requires a namespace).

## Create a namespace

To start creating rules and volumes, at least one namespace is required.
To create a namespace, run:

```bash
$ storageos namespace create legal --description compliance-volumes
legal
```

Add the `--display-name` flag to set a display-friendly name.

## List all namespaces

To view namespaces, run:

```bash
$ storageos namespace ls -q
default
legal
performance
```

Remove `-q` for full details

## Inspect namespaces

Check if a namespace has labels applied.

```bash
$ storageos namespace inspect legal | grep labels
        "labels": null,
```

## Removing a namespace

Removing a namespace will remove all volumes and rules that belong to that
namespace. An API call or CLI command to remove a namespace will fail if there
are mounted volumes to prevent data loss.

To remove a namespace:

```bash
$ storageos namespace rm legal
legal
```

To force remove, even if there are mounted volumes:

```bash
storageos namespace rm --force my-namespace
```

# Pools

Pools are used to create collections of storage resources created from StorageOS
cluster nodes.

Pools are used to organize storage resources into common collections such as
class of server, class of storage, location within the datacenter or subnet.
Cluster nodes can participate in more than one pool.

## Using pools

Volumes are provisioned from pools.  If a pool name is not specified when the
volume is created, the default pool name (`default`) will be used.

To create and manage pools individually, use the [storageos pool command]({%
link _docs/reference/cli/pool.md %}) to manage which nodes participate in the
pool (via controllers) and the drivers to use.

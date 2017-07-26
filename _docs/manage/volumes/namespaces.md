---
layout: guide
title: StorageOS Docs - Namespaces
anchor: manage
module: manage/volumes/namespaces
# Last reviewed by cheryl.hung@storageos.com on 2017-04-13
---


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

---
layout: guide
title: Create and manage namespaces
anchor: manage
module: manage/namespaces
---

# Namespaces

Namespaces are used to isolate environments and make operations quicker, eg. cleaning up all volumes and rules within a testing environment with a single `storageos namespace rm` command.
Users can have any number of namespaces.

*Note*: Docker does not support namespaces on volumes, so use the `default` namespace for Docker containers.

## Create a namespace

To start creating rules and volumes, at least one namespace is required.
To create a namespace, run:

    storageos namespace create my-namespace

Add the `--display-name` flag to set a display-friendly name.

## List all namespaces

To view namespaces, run:

    storageos namespace ls

## Removing namespace

Removing a namespace will remove all volumes and rules that belong to that namespace. API call or CLI command to remove a namespace will fail if there are mounted volumes (to prevent data loss).

To remove a namespace:

    storageos namespace rm my-namespace

Force remove:

    storageos namespace rm --force my-namespace

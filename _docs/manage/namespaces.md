---
layout: guide
title: Create and manage namespaces
anchor: manage
module: manage/namespaces
---

# Namespaces

Namespaces are used to isolate environments and make operations quicker, i.e. cleaning up testing environment volumes & rules with a single `storageos namespace rm` command. Users can have any number of namespaces. 

## Create a namespace

You need to have at least one namespace to start creating rules and volumes.
To create a namespace, run:

    storageos namespace create --display-name MyNamespace mynamespace

flag `--display-name` is optional, it will default to actual namespace name.

## List all namespaces

To view namespaces, run:

    storageos namespace ls

## Removing namespace

Removing a namespace will remove all volumes and rules that belong to that namespace. API call or CLI command to remove a namespace will fail if there are mounted volumes (to prevent data loss). 

To remove a namespace:

    storageos namespace rm third
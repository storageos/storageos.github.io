---
layout: guide
title: Create and manage namespaces
anchor: manage
module: manage/namespaces
---

# Namespaces

Namespaces are used to isolate environments and make operations quicker, i.e. cleaning up testing environment volumes & rules with a single `storageos namespace rm` command. 
Users can have any number of namespaces. 

## Create a namespace

To start creating rules and volumes, at least one namespace is required. 
To create a namespace, run:

    storageos namespace create --display-name "My Namespace" my-namespace

flag `--display-name` is optional, it will default to actual namespace name.

## List all namespaces

To view namespaces, run:

    storageos namespace ls

## Removing namespace

Removing a namespace will remove all volumes and rules that belong to that namespace. API call or CLI command to remove a namespace will fail if there are mounted volumes (to prevent data loss). 

To remove a namespace:

    storageos namespace rm my-namespace

Force remove:

    storageos namespace rm --force my-namespace    
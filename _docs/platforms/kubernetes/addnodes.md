---
layout: guide
title: StorageOS Docs - Adding and removing nodes
anchor: platforms
module: platforms/kubernetes/addnodes
---

# Add nodes

Nodes may be added to a cluster by running the StorageOS container with `JOIN`
set to the IP addresses of one of the nodes.

# Remove nodes

It is currently not possible for a node to leave the cluster completely. If the
StorageOS container is stopped and/or removed from a node then the node will be
detected as failed and it will be marked offline, but there is no way to remove
the node from the list.

The next release will provide functionality to cleanly remove a node.

To drain the node:
```bash
storageos node drain storageos-1
```

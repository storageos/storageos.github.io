---
layout: guide
title: StorageOS Docs - Upgrades
anchor: operations
module: operations/node
---

# Upgrading a cluster

## Adding nodes

Nodes may be added to a cluster by running the StorageOS container with `JOIN`
set to the IP addresses of one of the nodes.

## Upgrading StorageOS

Upgrades can be performed by restarting the StorageOS node container with the
new version. You can disable scheduling new volumes on the node with `storageos
node cordon` before upgrading the node, and move all volumes to other nodes with
`storageos node drain`.

## Removing nodes

It is currently not possible for a node to leave the cluster completely. If the
StorageOS container is stopped and/or removed from a node then the node will be
detected as failed and it will be marked offline, but there is no way to remove
the node from the list. `storageos node rm` will be added shortly as a way to
cleanly remove a node.

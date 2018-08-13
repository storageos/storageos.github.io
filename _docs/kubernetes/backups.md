---
layout: guide
title: StorageOS Docs - Upgrading StorageOS
anchor: kubernetes
module: kubernetes/backups
---

## Upgrading StorageOS

Upgrades can be performed by restarting the StorageOS node container with the
new version. You can disable scheduling new volumes on the node with `storageos
node cordon` before upgrading the node.

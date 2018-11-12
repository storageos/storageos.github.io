---
layout: guide
title: StorageOS Docs - Pools
anchor: concepts
module: concepts/pools
---

# Pools

StorageOS aggregates host storage from all nodes where the StorageOS container
runs into a storage pool. A Pool is a  collection of storage based on host
attributes such as class of server, storage or location.

Node storage can be allocated to a specific pool using Node selectors. Pool node
selectors look for labels on host nodes and will aggregate storage from nodes
whose labels match into the specific pool.

Pools can have labels applied to them such as `storageos.com/overcommit` which
allows the pool to have it's storage [overcommited]({% link
_docs/reference/labels.md %})

---
layout: guide
title: StorageOS Docs - Decommissioning of Nodes
anchor: operations
module: operations/decommission-nodes
---

# Decommissioning StorageOS Nodes

StorageOS nodes can be decommissioned and removed from the cluster using the
StorageOS CLI.

> This functionality is only available when StorageOS is deployed with
> `KV_BACKEND=etcd`, so the KV store is external to StorageOS. Please see the
> [deploy etc-as-svc example for more information](https://github.com/storageos/deploy/tree/master/k8s/deploy-storageos/etcd-as-svc)
> for more information.

There are safeguards to make sure data is not lost unintentionally. Only nodes
in state `Offline` can be removed from the StorageOS cluster. Note that once
removed from the cluster, nodes may not partake in StorageOS operations, and
may not run container applications that require StorageOS backed persistent
storage.

The recommended procedure is as follows. 

1. Cordon the node

    ```bash
    $ storageos node cordon node03
    node03
    ```

1. Drain the node

    ```bash
    $ storageos node drain node03
    node03
    ```

    > Wait until the node drain is finished. Check the volumes located on that
    > node with `storageos node ls` and wait until there are no Masters or
    > Replicas on the drained node. If there are no eligible nodes for 
    > replicas to be created on, the drained node will keep hosting them.

1. Stop the node

1. Delete the node from the cluster

    ```bash
    $ storageos node delete node03
    node03
    ```


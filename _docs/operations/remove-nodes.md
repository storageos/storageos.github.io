---
layout: guide
title: StorageOS Docs - Decomissioning of nodes
anchor: operations
module: operations/remove-nodes
---

# Remove StorageOS nodes

StorageOS nodes can be decommissioned and removed from the cluster using the
StorageOS cli.

> This functionality is only available when StorageOS is deployed with
> `KV_BACKEND=etcd`, so the kv store is external to StorageOS.

The deletion of a node has safeguards to make sure data is not lost
unwillingly. Only nodes in state: `Offline` can be removed from the StorageOS
cluster. Mind that any physical host or VM that doesn't have StorageOS
container running will not only be able to use its storage backend to provision
volumes but it wont be able to mount StorageOS volumes into the containers
scheduled in that node.

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

    > Wait until the node drain is finished. Check the volumes living in that
    > node with `storageos node ls` and wait until there is no Masters or
    > Replicas in that node. If replicas has no node available to be created
    > the drained node will keep hosting them.

1. Stop the node

1. Delete the node from the cluster

    ```bash
    $ storageos node delete node03
    node03
    ```


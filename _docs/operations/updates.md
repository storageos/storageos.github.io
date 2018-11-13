---
layout: guide
title: StorageOS Docs - Update StorageOS version
anchor: operations
module: operations/updates
---

# Update StorageOS version

> Before upgrading, check the 
> [release notes]({%link _docs/reference/release_notes.md %}) to confirm
> whether there is a safe upgrade path between versions.


StorageOS version upgrades must be planned and executed taking in consideration
that data will remain inaccessible during the process. It is recommended to
schedule a maintenance window.

There are two strategies to update StorageOS.

1. Full stop of the cluster
1. Rolling update

## Option 1. Full stop of the cluster

This option consists on downscaling all applications using StorageOS volumes
to 0, stop all StorageOS pods, start StorageOS with new version and rescale
applications to previous size.

This option will not require moving data across nodes, therefore it is
recommended for clusters with large data sets. However, __it implies downtime__ of
the stateful applications.

Follow next steps to perform this upgrade

1. Make sure all nodes have the new StorageOS image pulled, so the new
   containers will start promptly (optional). 
   ```bash
  docker pull storageos/node:$NEW_VERSION
   ```
1. Downscale any applications using StorageOS volumes to 0.

    > Any mount points will hang while StorageOS Pods are not present if the
    > application Pods haven't been stopped.

1. Set the StorageOS cluster in maintenance mode.

    StorageOS implements a maintenance mode that freezes the cluster. When in
    maintenance mode, StorageOS operations are limited. Functionalities such volume
    provisioning, failover of primary volumes or managing nodes is disabled. For
    more details see the [Maintenance]<!-- todo --> page.
1. Make sure the update strategy of StorageOS is `OnDelete`.
    ```bash
   $ export NAMESPACE=storageos
   $ export DAEMONSET_NAME=storageos
   $ kubectl -n $NAMESPACE get ds/$DAEMONSET_NAME -o {% raw %}go-template='{{.spec.updateStrategy.type}}{{"\n"}}'{% endraw %}
   OnDelete
    ```

1. Change the StorageOS version for the StorageOS node container

    ```bash
   $ kubectl -n $NAMESPACE set image ds/$DAEMONSET_NAME storageos=storageos/node:$NEW_VERSION
    ```

1. Delete StorageOS Pods.

    ```bash
    $ kubectl -n $NAMESPACE delete --selector app=storageos 
    ```

1. Check that StorageOS is starting and wait until the Pods are in `ready` state.

    ```bash
   $ kubectl -n $NAMESPACE get pods
    ```

1. Scale up the applications that where using StorageOS volumes, once StorageOS
   is up and running.


## Option 2. Manual rolling update

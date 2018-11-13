---
layout: guide
title: StorageOS Docs - Upgrade StorageOS version
anchor: operations
module: operations/upgrades
---

# Upgrade StorageOS version

> Before upgrading, check the 
> [release notes]({%link _docs/reference/release_notes.md %}) to confirm
> whether there is a safe upgrade path between versions.


StorageOS version upgrades must be planned and executed taking into consideration
that data will remain inaccessible during the process. It is recommended to
schedule a maintenance window.

There are two strategies to upgrade StorageOS for now. And both keep data
consistency during the upgrade process. StorageOS keeps the data in the host
where it is running. When the new version of StorageOS starts, the volumes from
the previous version are available.

1. Full stop of the cluster
1. Rolling update

> More upgrade procedures will be released that will automate the main part of
> the process and fulfil use cases not covered currently.

## Option 1. Full stop of the cluster

This option consists of downscaling all applications using StorageOS volumes to
0 (only those mounting volumes), stop all StorageOS pods, start StorageOS with
new version and rescale applications to previous size. Deployments that don't
use StorageOS volumes remain unaffected.

This option will not require moving data across nodes, therefore it is
recommended for clusters with large data sets. However, __it implies downtime__ for
stateful applications.

Execute the following instructions:

1. Make sure all nodes have the new StorageOS image pulled, so the new
   containers will start promptly (optional). 
   ```bash
  docker pull storageos/node:$NEW_VERSION
   ```
1. Downscale any applications using StorageOS volumes to 0.

    > Any mount points will hang while StorageOS Pods are not present if the
    > application Pods haven't been stopped.

1. Put the StorageOS cluster in maintenance mode.

    StorageOS implements a maintenance mode that freezes the cluster. When in
    maintenance mode, StorageOS operations are limited. Functionalities such as
    volume provisioning, failover of primary volumes or managing nodes are
    disabled. For more details see the [Maintenance]<!-- todo --> page.
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

1. Scale up the applications that were using StorageOS volumes, once StorageOS
   is up and running.


## Option 2. Manual rolling update

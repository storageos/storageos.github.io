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
that data will be inaccessible during the process. It is recommended to
schedule a maintenance window.

Currently there are two strategies to upgrade StorageOS and both maintain data
consistency during the upgrade process. StorageOS keeps the data in the hosts
where the StorageOS container is running. When the new version of StorageOS starts,
the volumes from the previous version are available.

1. Full stop of the cluster
1. Rolling update

> More upgrade procedures will be released that will automate the main part of
> the process and fulfil use cases not covered currently.

> The [StorageOS cli]({%link _docs/reference/cli/index.md %}) is required to perform an upgrade.

## Option 1. Full stop of the cluster

This option consists of downscaling all applications using StorageOS volumes to
0 (only those mounting volumes), stop all StorageOS pods, start StorageOS with
new version and rescale applications to previous size. Deployments that don't
use StorageOS volumes remain unaffected.

This option will not require moving data across nodes, therefore it is
recommended for clusters with large data sets. However, __it implies downtime__ for
stateful applications.

Execute the following instructions:

Prepare upgrade:

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

Execute update:

1. Change the StorageOS version for the StorageOS node container

    ```bash
   kubectl -n $NAMESPACE set image ds/$DAEMONSET_NAME storageos=storageos/node:$NEW_VERSION
    ```

1. Delete StorageOS Pods.

    ```bash
   kubectl -n $NAMESPACE delete --selector app=storageos 
    ```

1. Check that StorageOS is starting and wait until the Pods are in `ready` state.

    ```bash
   kubectl -n $NAMESPACE get pods
    ```

1. Scale up the applications that were using StorageOS volumes, once StorageOS
   is up and running.


## Option 2. Manual rolling update


This option consists of moving stateful applications and StorageOS volumes from
a node, applying the version upgrade and repeating this process for every node.
Only Pods using StorageOS nodes will need to be evicted.

This option requires the promotion of replicas and data to be rebuilt on new nodes
at least once per volume. It is possible to wait for volumes without replicas
to be evicted from a node, alternatively follow the steps below. Please note that
it is recommended to create at least one replica per node for the purpose of the upgrade.

Clusters with large data sets or a large number nodes might take a long time to
finish the procedure.

This procedure requires __a restart of the stateful pods__ at least twice during
the procedure.

The amount of nodes you can upgrade at the same time will depend on the amount
of replicas the volumes have. With 2 replicas per volume, it is possible to
update 2 nodes at a time without causing unavailability of data apart from the
the application stop/start. It is recommended to upgrade one node at a time.

Execute the following instructions:

Prepare upgrade:

1. Prepare an etcd backup if using external etcd.
1. Make sure all nodes have the new StorageOS image pulled, so the new
   containers will start promptly (optional). 
   ```bash
   docker pull storageos/node:$NEW_VERSION
   ```

1. Make sure the update strategy of StorageOS is `OnDelete`.
    ```bash
   $ export NAMESPACE=storageos
   $ export DAEMONSET_NAME=storageos
   $ kubectl -n $NAMESPACE get ds/$DAEMONSET_NAME -o {% raw %}go-template='{{.spec.updateStrategy.type}}{{"\n"}}'{% endraw %}
   OnDelete
    ```
1. Make sure that all volumes have at least one replica

    ```bash
    # Save what volumes had 0 replicas to restore to that state later
    $ storageos volume ls --format "table {{.Name}}\t{{.Replicas}}"  | grep '0/0' | awk '{ print $1  }' > /var/tmp/volume-0-replicas.txt

    # Update volumes to enable 1 replica
    $ storageos volume ls --format "table {{.Name}}\t{{.Replicas}}"  | grep '0/0' | awk '{ print $1  }' | xargs -I{} storageos volume update --label-add storageos.com/replicas=1 {}
    ```

1. Wait until all replicas are synced (1/1)

    ```bash
    {% raw %}
    $ storageos volume ls --format "table {{.Name}}\t{{.Replicas}}" 
    NAMESPACE/NAME                                      REPLICAS
    default/pvc-166ba271-e75c-11e8-8a20-0683b54ab438    0/1
    mysql/pvc-2b38b2e2-e75c-11e8-8a20-0683b54ab438      0/1
    postgress/pvc-3b39f530-e75c-11e8-8a20-0683b54ab438  0/1
    redis/pvc-8b8b37eb-e75d-11e8-8a20-0683b54ab438      0/1
    (...)
    $ storageos volume ls --format "table {{.Name}}\t{{.Replicas}}" 
    NAMESPACE/NAME                                      REPLICAS
    default/pvc-166ba271-e75c-11e8-8a20-0683b54ab438    1/1
    mysql/pvc-2b38b2e2-e75c-11e8-8a20-0683b54ab438      1/1
    postgress/pvc-3b39f530-e75c-11e8-8a20-0683b54ab438  1/1
    redis/pvc-8b8b37eb-e75d-11e8-8a20-0683b54ab438      1/1
    {% endraw %}
    ```

Execute the upgrade:
1. Change the StorageOS version for the StorageOS node container

    ```bash
   kubectl -n $NAMESPACE set image ds/$DAEMONSET_NAME storageos=storageos/node:$NEW_VERSION
    ```

1. Cordon and drain node

    ```bash
   # Select what node is being manipulated 
   export NODE=node01 # Define your node
   storageos node cordon $NODE
   storageos node drain $NODE
   kubectl cordon $NODE
   kubectl drain --ignore-daemonsets $NODE
    ```
    > If there are many Pods running stateless applications that don't need to
    > be evicted, you can delete the stateful Pods after the `kubectl cordon
    > $NODE` so they start in a different node and omit the `kubectl drain
    > $NODE`

1. Delete StorageOS Pod.

    ```bash
   kubectl -n $NAMESPACE get pod -owide --no-headers | grep "$NODE" | awk '{print $1}' | xargs -I{} kubectl -n $NAMESPACE delete pod {}
    ```

1. Wait until StorageOS Pod with the new version is started and ready.

    ```bash
   $ kubectl -n $NAMESPACE get pod -owide --no-headers | grep "$NODE" | awk '{print $1}' | xargs -I{} kubectl -n $NAMESPACE get pod {}
    NAME              READY     STATUS    RESTARTS   AGE
    storageos-j7pqf   1/1       Running   0          3m
    ```

1. Uncordon node

    ```bash
   storageos node uncordon $NODE
   storageos node undrain $NODE
   kubectl uncordon $NODE
    ```
1. Repeat from point 2 for every node of the cluster

> Once you are finished with all nodes, remove the replicas of the volumes that
> didn't have them on the first place.

```bash
while read vol; do
  storageos volume update --label-add storageos.com/replicas=0 $vol
done </var/tmp/volume-0-replicas.txt
```

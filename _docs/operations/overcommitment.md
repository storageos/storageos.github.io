---
layout: guide
title: StorageOS Docs - Overcommitment
anchor: operations
module: operations/overcommitment
---

# Overcommitment

Overcommitment is a way of creating volumes whose size exceeds the actual
storage presented by underlying nodes. It can be useful if you anticipate
writing a lot of data to a volume eventually but you do not wish to pay for
storage that is not currently being used.

Given a 120GB pool comprised of 3 nodes with 40GB disks, then the maximum
volume size is 40GB. To ensure deterministic performance and replication of writes,
StorageOS volumes must fit on a single node. Therefore if the pool
is overcommitted by 20% then the new pool size is 144GB and the new maximum
volume size is 48GB.

With hetrogenous node capacities it is important to keep in mind that a
volume cannot be provisioned on a node without capacity that is equal
to, or larger than the volume size.

For example given a 250GB pool, which is made up of a 200GB node and a
50GB node then StorageOS will not collocate volumes whose total size is larger
than 50GB on the 50GB node. If the pool is overcommited by 10% then volumes up
to 55GB could be scheduled on the 50GB node, and volumes up to 220GB on the 200GB
node.

## Adding an Overcommit label to a pool

To add a overcommit label to a pool you can use the CLI or GUI. 

With the CLI:

```bash
$ storageos pool update --label-add storageos.com/overcommit=20 default
```
The command above would set overcommit to 20% on the default pool.

```bash
$ storageos pool update --label-rm storageos.com/overcommit default
```
The command above removes the overcommit label from the default pool.

With the GUI: 

Navigate to Pools and click on the labels row of the volume you would like to
edit. In the popup menu you can add and remove labels.
![image](/images/docs/gui/pool-label.png)

For more information on feature labels please see [here](/docs/reference/labels#storageos-pool-labels).

## One node clusters 

### Issue: 
StorageOS nodes have started creating multiple clusters of one node, rather
than one cluster of many nodes.

```bash
root@node1:~# storageos -H node1 node ls
NAME                ADDRESS             HEALTH                   SCHEDULER           VOLUMES             TOTAL
node1               172.28.128.3        Healthy About a minute   true                M: 0, R: 0          8.699GiB
root@node1:~# storageos -H node2 node ls 
NAME                ADDRESS             HEALTH                   SCHEDULER           VOLUMES             TOTAL
node2               172.28.128.4        Healthy About a minute   true                M: 0, R: 0          8.699GiB
root@node1:~# storageos -H node3 node ls 
NAME                ADDRESS             HEALTH                   SCHEDULER           VOLUMES             TOTAL
node3               172.28.128.5        Healthy About a minute   true                M: 0, R: 0          8.699GiB
root@node1:~# storageos -H node4 node ls 
NAME                ADDRESS             HEALTH                   SCHEDULER           VOLUMES             TOTAL
node4               172.28.128.6        Healthy About a minute   true                M: 0, R: 0          8.699GiB
```

### Reason:

The `JOIN` variable has been misconfigured. One common mistake is to set the
variable to `localhost` or set to the value of the `ADVERTISE_IP`.

> Installations with Helm might cause this behaviour unless the `JOIN` parameter
> is explicitly defined.

StorageOS uses the `JOIN` variable to discover other nodes in the cluster during
the node bootstrapping process. It must be set to one or more active nodes. 

> You don't actually need to specify all the nodes. Once a new StorageOS node
> can connect to a member of the cluster the gossip protocol discovers the
> whole list of members. For high availability during the bootstrap process, it
> is recommended to set up as many as possible, so if one node is unavailable
> at the bootstrap process the next in the list will be queried.

### Solution:
Define the `JOIN` variable according to the [discovery documentation]({%link
_docs/reference/clusterdiscovery.md %}).

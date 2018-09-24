## Peer discovery - Networking

### Issue:
StorageOS nodes can't join the cluster showing the following logs.

> This error keeps appearing after 1 min of starting StorageOS.

```bash
time="2018-09-24T13:40:20Z" level=info msg="not first cluster node, joining first node" action=create address=172.28.128.5 category=etcd host=node3 module=cp target=172.28.128.6
time="2018-09-24T13:40:20Z" level=error msg="could not retrieve cluster config from api" status_code=503
time="2018-09-24T13:40:20Z" level=error msg="failed to join existing cluster" action=create category=etcd endpoint="172.28.128.3,172.28.128.4,172.28.128.5,172.28.128.6" error="503 Service Unavailable" module=cp
time="2018-09-24T13:40:20Z" level=info msg="retrying cluster join in 5 seconds..." action=create category=etcd module=cp
```

### Reason:
StorageOS uses a gossip protocol to discover the nodes in the cluster. When StorageOS starts, one
or more nodes can be referenced so new nodes can query existing ones for the list of members. This error
indicates that the node can't connect to any of the nodes in the known list. The known list is
defined in the `JOIN` variable.

### Doublecheck:

It is likely that ports are block by a firewall.

SSH into one of your nodes and check connectivity to the rest of the nodes.
```bash
# Successfull execution:
[root@node06 ~]# nc -zv node04 5705
Ncat: Version 7.50 ( https://nmap.org/ncat  )
Ncat: Connected to 10.0.1.166:5705.
Ncat: 0 bytes sent, 0 bytes received in 0.01 seconds.
```

### Solution:
Open ports following the [prerequisites page]({%link _docs/prerequisites/firewalls.md %}).



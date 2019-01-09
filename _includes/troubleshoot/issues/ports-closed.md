## Peer discovery - Networking

### Issue:
StorageOS nodes can't join the cluster showing the following logs after one
minute of container uptime.

```bash
time="2018-09-24T13:40:20Z" level=info msg="not first cluster node, joining first node" action=create address=172.28.128.5 category=etcd host=node3 module=cp target=172.28.128.6
time="2018-09-24T13:40:20Z" level=error msg="could not retrieve cluster config from api" status_code=503
time="2018-09-24T13:40:20Z" level=error msg="failed to join existing cluster" action=create category=etcd endpoint="172.28.128.3,172.28.128.4,172.28.128.5,172.28.128.6" error="503 Service Unavailable" module=cp
time="2018-09-24T13:40:20Z" level=info msg="retrying cluster join in 5 seconds..." action=create category=etcd module=cp
```

### Reason:
StorageOS uses a gossip protocol to discover the nodes in the cluster. When
StorageOS starts, one or more nodes can be referenced so new nodes can query
existing ones for the list of members. This error indicates that the node can't
connect to any of the nodes in the known list. The known list is defined in the
`JOIN` variable.

### Assert:

It is likely that ports are block by a firewall.

SSH into one of your nodes and check connectivity to the rest of the nodes.
```bash
# Successfull execution:
[root@node06 ~]# nc -zv node04 5705
Ncat: Version 7.50 ( https://nmap.org/ncat  )
Ncat: Connected to 10.0.1.166:5705.
Ncat: 0 bytes sent, 0 bytes received in 0.01 seconds.
```

StorageOS exposes network diagnostics in its API, viewable from the CLI.  To
use this feature, the CLI must query the API of a running node. The diagnostics
show information from all known cluster members. If all the ports are blocked
during the first bootstrap of the cluster, the diagnostics won't show any data
as nodes couldn't register.

> StorageOS networks diagnostics are available for storageos-rc5 and
> storageos-cli-rc3 and above.

```bash
# Example:
root@node1:~# storageos cluster connectivity
SOURCE  NAME            ADDRESS            LATENCY      STATUS  MESSAGE
node4   node2.nats      172.28.128.4:5708  1.949275ms   OK
node4   node3.api       172.28.128.5:5705  3.070574ms   OK
node4   node3.nats      172.28.128.5:5708  2.989238ms   OK
node4   node2.directfs  172.28.128.4:5703  2.925707ms   OK
node4   node3.etcd      172.28.128.5:5707  2.854726ms   OK
node4   node3.directfs  172.28.128.5:5703  2.833371ms   OK
node4   node1.api       172.28.128.3:5705  2.714467ms   OK
node4   node1.nats      172.28.128.3:5708  2.613752ms   OK
node4   node1.etcd      172.28.128.3:5707  2.594159ms   OK
node4   node1.directfs  172.28.128.3:5703  2.601834ms   OK
node4   node2.api       172.28.128.4:5705  2.598236ms   OK
node4   node2.etcd      172.28.128.4:5707  16.650625ms  OK
node3   node4.nats      172.28.128.6:5708  1.304126ms   OK
node3   node4.api       172.28.128.6:5705  1.515218ms   OK
node3   node2.directfs  172.28.128.4:5703  1.359827ms   OK
node3   node1.api       172.28.128.3:5705  1.185535ms   OK
node3   node4.directfs  172.28.128.6:5703  1.379765ms   OK
node3   node1.etcd      172.28.128.3:5707  1.221176ms   OK
node3   node1.nats      172.28.128.3:5708  1.330122ms   OK
node3   node2.api       172.28.128.4:5705  1.238541ms   OK
node3   node1.directfs  172.28.128.3:5703  1.413574ms   OK
node3   node2.etcd      172.28.128.4:5707  1.214273ms   OK
node3   node2.nats      172.28.128.4:5708  1.321145ms   OK
node1   node4.directfs  172.28.128.6:5703  1.140797ms   OK
node1   node3.api       172.28.128.5:5705  1.089252ms   OK
node1   node4.api       172.28.128.6:5705  1.178439ms   OK
node1   node4.nats      172.28.128.6:5708  1.176648ms   OK
node1   node2.directfs  172.28.128.4:5703  1.529612ms   OK
node1   node2.etcd      172.28.128.4:5707  1.165681ms   OK
node1   node2.api       172.28.128.4:5705  1.29602ms    OK
node1   node2.nats      172.28.128.4:5708  1.267454ms   OK
node1   node3.nats      172.28.128.5:5708  1.485657ms   OK
node1   node3.etcd      172.28.128.5:5707  1.469429ms   OK
node1   node3.directfs  172.28.128.5:5703  1.503015ms   OK
node2   node4.directfs  172.28.128.6:5703  1.484ms      OK
node2   node1.directfs  172.28.128.3:5703  1.275304ms   OK
node2   node4.nats      172.28.128.6:5708  1.261422ms   OK
node2   node4.api       172.28.128.6:5705  1.465532ms   OK
node2   node3.api       172.28.128.5:5705  1.252768ms   OK
node2   node3.nats      172.28.128.5:5708  1.212332ms   OK
node2   node3.directfs  172.28.128.5:5703  1.192792ms   OK
node2   node3.etcd      172.28.128.5:5707  1.270076ms   OK
node2   node1.etcd      172.28.128.3:5707  1.218522ms   OK
node2   node1.api       172.28.128.3:5705  1.363071ms   OK
node2   node1.nats      172.28.128.3:5708  1.349383ms   OK
```
### Solution:
Open ports following the [prerequisites page]({%link
_docs/prerequisites/firewalls.md %}).



## Peer discovery - Pod allocation

### Issue:
StorageOS nodes can't join the cluster showing the following logs.

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

If there are no active StorageOS nodes, the bootstrap process will elect the first node in the `JOIN` variable 
as master, hence the rest will try to discover from it. In case of that node not starting, the whole cluster will remain unable to bootstrap.

Installations of StorageOS on {{ page.platform }} use a DaemonSet, which by default they might be able to be allocated in master nodes.
If that happens but the master node has not been configured to run workloads, the StorageOS Pod will never start. If by chance, the JOIN variable was defined listing that node as the first in the list, the StorageOS cluster will remain unable to start.

### Doublecheck:

Check that the first node of the `JOIN` variable started properly.

```bash
{{ page.cmd }} -n storageos describe ds/storageos | grep JOIN
{{ page.cmd }} -n storageos get pod -o wide
```

### Solution:

Make sure that the `JOIN` variable doesn't specify the master nodes. In case you are using the discovery service, it is necessary to ensure that the DaemonSet can't allocate Pods in the masters. This can be achieved with taints, node selectors or labels.

An [example of deployment](https://github.com/storageos/deploy/tree/master/k8s/deploy-storageos/labeled-deployment) is available to see how to run StorageOS with node labels.

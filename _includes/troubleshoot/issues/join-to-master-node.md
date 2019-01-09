## Peer discovery - Pod allocation

### Issue:
StorageOS nodes can't join the cluster and show the following log entries.

```bash
time="2018-09-24T13:40:20Z" level=info msg="not first cluster node, joining first node" action=create address=172.28.128.5 category=etcd host=node3 module=cp target=172.28.128.6
time="2018-09-24T13:40:20Z" level=error msg="could not retrieve cluster config from api" status_code=503
time="2018-09-24T13:40:20Z" level=error msg="failed to join existing cluster" action=create category=etcd endpoint="172.28.128.3,172.28.128.4,172.28.128.5,172.28.128.6" error="503 Service Unavailable" module=cp
time="2018-09-24T13:40:20Z" level=info msg="retrying cluster join in 5 seconds..." action=create category=etcd module=cp
```

### Reason:
StorageOS uses a gossip protocol to discover the nodes in the cluster. When
StorageOS starts, one or more active nodes must be referenced so new nodes can
query existing ones for the list of members. This error indicates that the node
can't connect to any of the nodes in the known list. The known list is defined
in the `JOIN` variable.

If there are no active StorageOS nodes, the bootstrap process will elect the
first node in the `JOIN` variable as master, and the rest will try to
discover from it. In case of that node not starting, the whole cluster will
remain unable to bootstrap.

Installations of StorageOS on {{ page.platform }} use a DaemonSet, and by
default do not schedule StorageOS pods to master nodes, due to the presence of
the `node-role.kubernetes.io/master:NoSchedule` taint in typical installations.
In such cases the `JOIN` variable must not contain master nodes or the
StorageOS cluster will remain unable to start.

### Assert:

Check that the first node of the `JOIN` variable started properly.

```bash
root@node1:~/# {{ page.cmd }} -n storageos describe ds/storageos | grep JOIN
    JOIN:          172.28.128.3,172.28.128.4,172.28.128.5
root@node1:~/# {{ page.cmd }} -n storageos get pod -o wide | grep 172.28.128.3
storageos-8zqxl   1/1       Running   0          2m        172.28.128.3   node1
```

### Solution:

Make sure that the `JOIN` variable doesn't specify the master nodes. In case
you are using the discovery service, it is necessary to ensure that the
DaemonSet won't allocate Pods on the masters. This can be achieved with taints,
node selectors or labels.

For installations with the StorageOS operator you can specify which nodes to
deploy StorageOS on using {% if page.platform == "OpenShift" %}[node
labels.](https://github.com/storageos/deploy/tree/master/openshift/deploy-storageos/cluster-operator#select-nodes-where-storageos-will-deploy)
{% else %}[node
labels.](https://github.com/storageos/deploy/tree/master/k8s/deploy-storageos/cluster-operator#select-nodes-where-storageos-will-deploy)
{% endif %}

{% if page.platform == "Kubernetes" %} For more advanced installations using
compute-only and storage nodes our [example
deployment](https://github.com/storageos/deploy/tree/master/k8s/deploy-storageos/labeled-deployment)
is available as an example of how to run StorageOS with node labels. {% else
%}{% endif %}

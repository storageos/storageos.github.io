
# StorageOS production installation

*Installation with DaemonSets on Kubernetes*

StorageOS tries to keep the installation simple for users, hence a barely no configuration bootstrap is possible. However, we present with best practices when availability and performance are key to the success of your applications. Checkout the StorageOS Helm [chart](https://github.com/storageos/helm-chart) for an easy automated installation.

StorageOS ships an embedded key value store service based on etcd. The etcd is used to keep cluster consistency among the StorageOS nodes. The first 5 nodes of StorageOS will deploy the etcd servers. Every other node doesn't start an etcd server, only the client component. A DaemonSet starts the pods without considering the order, therefore it is not possible to define which nodes of your cluster will start the etcd servers. Since the failure of the majority of the etcd servers (half of the etcd servers +1) could cause a lost in quorum, the StorageOS cluster could become unstable until the nodes are restored. It is recommended to keep the etcd servers as stable as possible. To guarantee high availability it is recommended to use one of the two following options.

1. Use an external etcd cluster
2. Run a compute only StorageOS daemonset where the etcd masters will run based on node labels. 

## External etcd cluster (+v3.0).

Deploy an external etcd cluster in high availability. Either 3 or 5 nodes to keep quorum.

You can find an example of the manifests in this [repository](https://github.com/storageos/demos/tree/master/k8s/deploy-storageos/external-etcd).

```
git clone https://github.com/storageos/demos.git storageos-examples
cd storageos-examples/demos/k8s/deploy-storageos/external-etcd
```

Once the etcd cluster is up and running, connect StorageOS with this cluster. To do so you can define a Kubernetes service and Endpoints to create an interface with the external etcd nodes. Edit the `manifests/025_etcd_service.yaml`, so the Endpoint' subsets.addresses point to your etcd addresses.

```
kind: Service
apiVersion: v1
metadata:
  name: etcd-storageos
  namespace: storageos
spec:
  ports:
  - protocol: TCP
    port: 2379
---
kind: Endpoints
apiVersion: v1
metadata:
    name: etcd-storageos
    namespace: storageos
subsets:
    - addresses: # IPs of your etcd servers
        - ip: 172.28.128.14
        - ip: 172.28.128.15
        - ip: 172.28.128.3
      ports:
        - port: 2379
```

After that, edit the `manifests/040_daemonset.yaml_template`. The deployment script fills the `KV_ADDR` with the ip of the k8s service. If your Kubernetes cluster can resolve the service name etcd-storageos, you can define that value as follows.

```
        env:
           - name: KV_BACKEND
             value: 'etcd'
           - name: KV_ADDR
             value: 'etcd-storageos:2379'
```

## Compute Only DaemonSet

Deploy a compute only StorageOS DaemonSet in the machines that will be responsible to run etcd servers, either 3 or 5 nodes. Once these pods are up and running, deploy the full StorageOS DaemonSet joining the same cluster.
   
First, it is required to label the Kubernetes nodes that host the StorageOS compute only DaemonSet. 

```
kubectl label node my_node1 my_node2 my_node3 storageos=compute-only
```

After that, label the rest of the nodes that will run StorageOS

```
kubectl label node my_nodeX storageos=storage
```

> Nodes not labeled doesn't run StorageOS in this installation procedure. Pods running in nodes where StorageOS is not present cannot mount volumes managed by StorageOS.

``` 
git clone https://github.com/storageos/demos.git storageos-examples
cd storageos-examples/demos/k8s/deploy-storageos/labeled-deployment
./deploy-storageos.sh
```

If your installation is executed from an orchestrator, it is manadatory to start the compute only DaemonSet manifest first, maybe defined as a prerequisite/dependency and deploy the storage DaemonSet afterwards. It is usually enough to wait for a minute, however, the best approach is to validate that the first DaemonSet is up and running. It can be achieved if the orchestrator doesn't create the resource from the manifest, but calls a wrapper script `deploy-storageos.sh` that can query the Kubernetes API and create the manifest accordingly.



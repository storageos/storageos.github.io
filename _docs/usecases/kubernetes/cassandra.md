---
layout: guide
title: StorageOS Docs - Cassandra
anchor: usecases
module: usecases/kubernetes/cassandra
---

# ![image](/images/docs/explore/cassandralogo.png) Cassandra with StorageOS

Cassandra is a popular distributed NoSQL open source database.

Using StorageOS persistent volumes with Cassandra means that if a Cassandra pod
fails, the cluster is only in a degraded state for as long as it takes
Kubernetes to restart the pod. When the pod comes back up the pod data is
immediately available. Should Kubernetes schedule the Cassandra pod on a
new node, StorageOS allows for the data to be available to the pod,
irrespective of whether or not a StorageOS master is located on the same node.

As Cassandra has features to allow it to handle replication careful
consideration of whether to allow StorageOS or Cassandra to handle replication
is required.

Before you start, ensure you have StorageOS installed and ready on a Kubernetes
cluster. [See our guide on how to install StorageOS on Kubernetes for more
information]({% link _docs/platforms/kubernetes/install/index.md %}).

## Deploying Cassandra on Kubernetes

1. You can find the latest files in the StorageOS use cases repository

   ```bash
   git clone https://github.com/storageos/use-cases.git storageos-usecases
   ```

   StatefulSet defintion

   ```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
 name: cassandra
spec:
 selector:
   matchLabels:
     app: cassandra
 serviceName: cassandra
 replicas: 3
 ...
 spec:
      ...
      volumeMounts:
       - name: cassandra-data
         mountPath: /var/lib/cassandra
 ...
volumeClaimTemplates:
 - metadata:
     name: cassandra-data
   spec:
     accessModes: ["ReadWriteOnce"]
     storageClassName: "fast" # StorageOS storageClass
     resources:
       requests:
         storage: 5Gi
   ```

   This excerpt is from the StatefulSet definition. This file contains the
   VolumeClaim template that will dynamically provision storage, using the
   StorageOS storage class. Dynamic provisioning occurs as a volumeMount has
   been declared with the same name as a VolumeClaimTemplate.

1. Move into the Cassandra examples folder and create the objects

   ```bash
   cd storageos-usecases
   kubectl create -f ./cassandra
   ```

1. Confirm Cassandra is up and running.

   ```bash
   $ kubectl get pods -w -l app=cassandra
   NAME          READY   STATUS    RESTARTS   AGE
   cassandra-0   1/1     Running   0          8m32s
   cassandra-1   1/1     Running   0          7m51s
   cassandra-2   1/1     Running   0          6m36s
   ```

1. Connect to the Cassandra client pod and connect to the Cassandra server through the
   service
   ```bash
   $ kubectl exec -it cassandra-0 -- cqlsh cassandra-0.cassandra
   Connected to K8Demo at cassandra-0.cassandra:9042.
   [cqlsh 5.0.1 | Cassandra 3.11.3 | CQL spec 3.4.4 | Native protocol v4]
   Use HELP for help.
   cqlsh> SELECT cluster_name, listen_address FROM system.local;

    cluster_name | listen_address
   --------------+----------------
          K8Demo |   100.96.7.124

   (1 rows)
   ```

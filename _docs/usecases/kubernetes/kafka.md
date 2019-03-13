---
layout: guide
title: StorageOS Docs - Kafka
anchor: usecases
module: usecases/kubernetes/kafka
---

# ![image](/images/docs/explore/kafka.png) <br><br> Kafka with StorageOS

Kafka is a popular stream processing platform combining features from pub/sub and traditional queues.

Using StorageOS persistent volumes with Apache Kafka means that if a pod
fails, the cluster is only in a degraded state for as long as it takes
Kubernetes to restart the pod. When the pod comes back up, the pod data is
immediately avaliable. Should Kubernetes schedule the kafka pod on a
new node, StorageOS allows for the data to be avaliable to the pod,
irrespective of whether or not a the original StorageOS master volume
is located on the same node.

As Kafka has features to allow it to handle replication, and as such careful
consideration of whether to allow StorageOS or Kafka to handle replication
is required.

Before you start, ensure you have StorageOS installed and ready on a Kubernetes
cluster. [See our guide on how to install StorageOS on Kubernetes for more
information]({% link _docs/platforms/kubernetes/install/index.md %})

## Deploying kafka on Kubernetes

### Pre-requisites

- Apache Zookeeper is required by Kafka to function; we assume it to already exist and be accessible within the Kubernetes cluster as `zookeeper`, see how to run Zookeeper with StorageOS
- StorageOS is assumed to have been installed; please check for the latest available version [here]({% link _docs/reference/release_notes %})

### Helm

To simplify the deployment of kafka, we've used the incubator [Kafka helm chart](//github.com/helm/charts/tree/master/incubator/kafka) version `0.13.8` with app version `5.0.1` and rendered it into the files you can find in our example deployment GitHub [repo](//github.com/storageos/deploy/tree/master/k8s/examples/kafka).

### Deployment

1. You can find the latest files in the StorageOS example deployment repostiory

  ```bash
  git clone https://github.com/storageos/deploy.git storageos
  ```

   StatefulSet defintion

  ```yaml
---
apiVersion: apps/v1beta1
kind: StatefulSet
spec:
  serviceName: kafka-headless
  podManagementPolicy: OrderedReady
  updateStrategy:
    type: OnDelete
  replicas: 3                            # <--- number of kafa pods to run
  template:
...
    spec:
      serviceAccountName: kafka
      containers:
...
        - name: kafka-broker
          image: "confluentinc/cp-kafka:5.0.1"
          imagePullPolicy: "IfNotPresent"
...
          volumeMounts:
            - name: datadir
              mountPath: "/var/data"
      volumes:
        - name: jmx-config
          configMap:
            name: kafka-metrics
      terminationGracePeriodSeconds: 60
  volumeClaimTemplates:
    - metadata:
        name: datadir
      spec:
        accessModes: ["ReadWriteOnce"]
        resources:
          requests:
            storage: 50Gi               # <--- storage requested for each pod
        storageClassName: "fast"        # <--- the StorageClass to use when provisioning the volume
  ```

   This excerpt is from the StatefulSet definition. The file contains the
   PersistentVolumeClaim template that will dynamically provision the necessary storage,
   using the StorageOS storage class. Dynamic provisioning occurs as a volumeMount has
   been declared with the same name as a VolumeClaimTemplate.

1. Move into the kafka examples folder and create the objects

   ```bash
   cd storageos
   kubectl create -f ./k8s/examples/kafka
   ```

1. Confirm kafka is up and running.

   ```bash
   $ kubectl get pods -w -l app=kafka
   NAME          READY   STATUS    RESTARTS   AGE
   kafka-0   1/1     Running   0          8m32s
   kafka-1   1/1     Running   0          7m51s
   kafka-2   1/1     Running   0          6m36s
   ```

1. Connect to the kafka client pod and connect to the kafka server through the
   service

   ```bash
   $ kubectl exec -it kafka-0 -- cqlsh kafka-0.kafka
   Connected to K8Demo at kafka-0.kafka:9042.
   [cqlsh 5.0.1 | kafka 3.11.3 | CQL spec 3.4.4 | Native protocol v4]
   Use HELP for help.
   cqlsh> SELECT cluster_name, listen_address FROM system.local;

    cluster_name | listen_address
   --------------+----------------
          K8Demo |   100.96.7.124

   (1 rows)
   ```

---
layout: guide
title: StorageOS Docs - Elasticsearch
anchor: usecases
module: usecases/kubernetes/elasticsearch
---

# ![image](/images/docs/explore/elasticsearch.png) Elasticsearch with StorageOS

Elasticsearch is a distributed, RESTful search and analytics engine, most
popularly used to aggregate logs, but also to serve as a search backend to a
number of different applications.

Using StorageOS persistent volumes with ElasticSearch (ES) means that if a pod
fails, the cluster is only in a degraded state for as long as it takes
Kubernetes to restart the pod. When the pod comes back up, the pod data is
immediately available. Should Kubernetes schedule the Elasticsearch pod on a
new node, StorageOS allows for the data to be available to the pod,
irrespective of whether or not the original StorageOS master volume
is located on the same node.

Elasticsearch has features to allow it to handle data replication, and as such
careful consideration of whether to allow StorageOS or Elasticsearch to handle
replication is required.

Before you start, ensure you have StorageOS installed and ready on a Kubernetes
cluster. [See our guide on how to install StorageOS on Kubernetes for more
information]({% link _docs/platforms/kubernetes/install/index.md %}).

## Deploying Elasticsearch on Kubernetes

### Prerequisites

Some OS tuning is required, which is done automatically when using our example
from the [use cases](https//github.com/storageos/use-cases.git) repository.

Elasticsearch requires `vm.max_map_count` to be increased to a minimum of
`262144`, which is a system wide setting. One way to achieve this is to
run `sysctl -w vm.max_map_count=262144` and update `/etc/sysctl.conf`
to ensure it persists over a reboot. See ElasicSearch reference
[here](https://www.elastic.co/guide/en/elasticsearch/reference/7.0/vm-max-map-count.html)

Administrators should be aware that this impacts the behaviour of nodes and
that there may be collisions with other application settings. Administrators
are advised to centrally collate sysctl settings using the tooling of their
choice.

### Deployment

&nbsp;


#### StatefulSet defintion

&nbsp;

  ```yaml
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: esdata

[...]

    spec:
      serviceAccountName: elasticsearch
      containers:
        - name: data
          image: elasticsearch:6.7.0
          imagePullPolicy: IfNotPresent

[...]

          volumeMounts:
            - name: data
              mountPath: /usr/share/elasticsearch/data/data

[...]

  volumeClaimTemplates:
    - metadata:
        name: "data"
      spec:
        accessModes: ["ReadWriteOnce"]
        storageClassName: "fast" # <--- default StorageOS storage class name
        resources:
          requests:
            storage: 10Gi   # <--- change this to the appropriate value
```

This excerpt is from the StatefulSet definition
(`/elasticsearch/10-es-data.yaml`). The file contains the
PersistentVolumeClaim template that will dynamically
provision the necessary storage, using the StorageOS storage class.

Dynamic provisioning occurs as a volumeMount has been declared with the same
name as a VolumeClaimTemplate.

## Prerequisites

Some OS tuning is required, which is done automatically when using our example
from the [deploy](//github.com/storageos/deploy) repository.

Elasticsearch requires `vm.max_map_count` to be increased to a minimum of
`262144`, which is a system wide setting. One way to achieve this is to
run `sysctl -w vm.max_map_count=262144` and update `/etc/sysctl.conf`
to ensure it persists over a reboot. See ElasicSearch reference
[here](https://www.elastic.co/guide/en/elasticsearch/reference/7.0/vm-max-map-count.html)

Administrators should be aware that this impacts the behaviour of nodes and
that there may be collisions with other application settings. Administrators
are advised to centrally collate sysctl settings using the tooling of their
choice.

#### Clone the use cases repo

&nbsp;

You can find the latest files in the StorageOS use cases repostiory
in `/elasticsearch/`

  ```bash
git clone https://github.com/storageos/use-cases.git storageos-usecases
cd storageos-usecases
```

&nbsp;

## Installation

1. Create the kubernetes objects
   
   
   > NOTE: this will install an ES cluster with 3 master, 3 data and 3
   coordinator nodes. Combined they will require ~ 14 GiB of available memory in
   your cluster, however, more may be used as the application is being used
   
     ```bash
   kubectl apply -f ./elasticsearch/
     ```
   
   Once completed, an internal service object will have been created making the
   cluster available as `http://elasticsearch:9200/` which is the default Kibana
   (when installed via Helm) will be using.

1. Confirm Elasticsearch is up and running


   ```bash
   kubectl get pods -l component=elasticsearch
   
   NAME                                    READY   STATUS    RESTARTS   AGE
   elasticsearch-exporter-d86ffd94-zw45l   1/1     Running   0          5m44s
   es-coordinator-b7b984dd4-7wlz5          1/1     Running   0          5m44s
   es-coordinator-b7b984dd4-89w26          1/1     Running   0          5m44s
   es-coordinator-b7b984dd4-b4t6j          1/1     Running   0          5m44s
   es-master-78dfd5b49f-9gf5c              1/1     Running   0          5m44s
   es-master-78dfd5b49f-smsbw              1/1     Running   0          5m44s
   es-master-78dfd5b49f-z4qpj              1/1     Running   0          5m44s
   esdata-0                                1/1     Running   0          5m44s
   esdata-1                                1/1     Running   0          4m34s
   esdata-2                                1/1     Running   0          3m22s
   ```

1. Connect to ElasticSearch

   To connect to ES directly, you can use the following port-forward command

   ```bash
   kubectl port-forward svc/elasticsearch 9200
   ```

   and then access it via [http://localhost:9200](http://localhost:9200)


## Kibana (optional)


One of the most popular uses of ES is to use it for log aggregation and
indexing, Kibana helps us visualize the data in these indices and can be
easily used when installed via its Helm chart

1. Install the helm chart.
   ```bash
   helm install stable/kibana
   ```

1. Once installed, use a port-foward to Kibana instead of directly to ES
   
   ```bash
   kubectl port-forward --namespace default $(kubectl get pods --namespace default -l "app=kibana" -o jsonpath="{.items[0].metadata.name}") 5601
   ```
   
   and then access it via [http://localhost:5601](http://localhost:5601)


## Monitoring (optional)

As part of the example deployment, ES metrics are exposed and can be scraped
by Prometheus on port 9108
(see [77-es-exporter.yaml](https://github.com/storageos/use-cases/blob/master/elasticsearch/77-es-exporter.yaml)).
This is enabled by default, and should work with the default Prometheus install
via Helm. If you're using the Prometheus service monitors, you can monitor
this installation by creating a monitor for the `es-exporter` service. For an
example of how this is done to monitor StorageOS, please see [prometheus-setup](/docs/operations/monitoring/prometheus-setup).

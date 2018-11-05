---
layout: guide
title: StorageOS Docs - Redis
anchor: platforms
module: platforms/kubernetes/examples/redis
---

# ![image](/images/docs/explore/redislogo.png) Redis with StorageOS

Redis is a popular networked, in-memory, key-value data store with optional durability to disk.

Before you start, ensure you have StorageOS installed and ready on a Kubernetes
cluster. [See our guide on how to install StorageOS on Kubernetes for more
information]({% link _docs/platforms/kubernetes/install/index.md %})

## Deploying Redis on Kubernetes

1. You can find the latest files in the StorageOS example deployment repostiory
   ```bash
   git clone https://github.com/storageos/deploy.git storageos
   ```
   StatefulSet defintion
  ```yaml
kind: StatefulSet
metadata:
 name: redis
spec:
 selector:
   matchLabels:
     app: redis
     env: prod
 serviceName: redis
 replicas: 1
 ...
 spec:
     serviceAccountName: redis
      ...
      volumeMounts:
       - name: data
         mountPath: /bitnami/redis/data
   ...
volumeClaimTemplates:
 - metadata:
     name: data
     labels:
       env: prod
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
   been declared with the same name as a Volume Claim.

1. Move into the Redis examples folder and create the objects

   ```bash
   cd storageos
   kubectl create -f ./k8s/examples/redis
   ```

1. Confirm Redis is up and running.

   ```bash
   $ kubectl get pods -w -l app=redis
   NAME        READY    STATUS    RESTARTS    AGE
   redis-0     1/1      Running    0          1m
   ```

1. Connect to the Redis client pod and connect to the Redis server through the
   service
   ```bash
    $ kubectl exec -it redis-0 -- redis-cli -a password
    Warning: Using a password with '-a' option on the command line interface may not be safe.
    127.0.0.1:6379> CONFIG GET maxmemory
    1) "maxmemory"
    2) "0"
    ```

## Configuration

If you need custom startup options, you can edit the ConfigMap with your desired Redis configuration settings.

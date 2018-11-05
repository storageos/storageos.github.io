---
layout: guide
title: StorageOS Docs - MySQL
anchor: usecases
module: usecases/kubernetes/mysql
---

# ![image](/images/docs/explore/mysqllogo.png) MySQL with StorageOS

MySQL is a popular SQL open source database for a wide range of popular
web-based applications including WordPress.

Before you start, ensure you have StorageOS installed and ready on a Kubernetes
cluster. [See our guide on how to install StorageOS on Kubernetes for more
information]({% link _docs/platforms/kubernetes/install/index.md %})

## Deploying MySQL on Kubernetes

1. You can find the latest files in the StorageOS example deployment repostiory
   ```bash
   git clone https://github.com/storageos/deploy.git storageos
   ```
   StatefulSet defintion
  ```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
 name: mysql
spec:
 selector:
   matchLabels:
     app: mysql
     env: prod
 serviceName: mysql
 replicas: 1
 ...
 spec:
     serviceAccountName: mysql
      ...
      volumeMounts:
       - name: data
         mountPath: /var/lib/mysql
         subPath: mysql
       - name: conf
         mountPath: /etc/mysql/mysql.conf.d
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

1. Move into the MySQL examples folder and create the objects

   ```bash
   cd storageos
   kubectl create -f ./k8s/examples/mysql
   ```

1. Confirm MySQL is up and running.

   ```bash
   $ kubectl get pods -w -l app=mysql
   NAME        READY    STATUS    RESTARTS    AGE
   mysql-0     1/1      Running    0          1m
   ```

1. Connect to the MySQL client pod and connect to the MySQL server through the
   service
   ```bash
   $ kubectl exec client -- mysql -h mysql-0.mysql -e "show databases;"
   Database
   information_schema
   mysql
   performance_schema
   ```

## Configuration

If you need custom startup options, you can edit the ConfigMap with your desired MySQL configuration settings.

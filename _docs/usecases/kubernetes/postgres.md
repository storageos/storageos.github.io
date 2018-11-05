---
layout: guide
title: StorageOS Docs - PostgreSQL
anchor: usecases
module: usecases/kubernetes/postgres
---

# ![image](/images/docs/explore/postgresqllogo.png) PostgreSQL with StorageOS

PostgreSQL or "Postgres" is an open source object-relational database management
system (ORDBMS).

Postgres is deployed across a wide variety of platforms with a mix of workloads
ranging from small, single-node use cases to large Internet-facing clusters
with many concurrent users.

Before you start, ensure you have StorageOS installed and ready on a Kubernetes
cluster. If you need to setup StorageOS on Kubernetes then please see our guide
to [installing StorageOS on Kubernetes]({% link
_docs/platforms/kubernetes/install/index.md %})

## Deploying PostgreSQL on Kubernetes

1. You can find the latest files in the StorageOS example deployment repostiory
   ```bash
   git clone https://github.com/storageos/deploy.git storageos
   ```
   PersistentVolumeClaim and Pod defintion excerpts
  ```yaml
    kind: PersistentVolumeClaim
    metadata:
    name: pg-data
    annotations:
     volume.beta.kubernetes.io/storage-class: fast

    kind: Pod
    metadata:
    name: postgress
    spec:
    securityContext:
     fsGroup: 26
    containers:
     - name: pg
       image: crunchydata/crunchy-postgres:centos7-10.4-1.8.3
       volumeMounts:
         - mountPath: /pgdata
           name: data
    ...
    volumes:
     - name: data
       persistentVolumeClaim:
         claimName: pg-data
  ```
  This excerpt is from the PersistentVolumeClaim and Pod definition. The pod
  definition references the pg-data VolumeClaim so storage is dynamically
  provision storage, using the StorageOS storage class. Dynamic provisioning
  occurs as a volumeMount has been declared with the same name as a Volume
  Claim.

1. Move into the PostgreSQL examples folder and create the objects

   ```bash
   cd storageos
   kubectl create -f ./k8s/examples/postgres
   ```

1. Confirm PostgreSQL is up and running.

   ```bash
   $ kubectl get pod postgres-0 -w 
   NAME         READY   STATUS    RESTARTS   AGE
   postgres-0   1/1     Running   0          1m
   ```

1. Connect to the PostgreSQL client pod and connect to the PostgreSQL server
   through the service.
   ```bash
   $ kubectl exec -it postgres-0 -- psql -h postgres-0.postgres -U primaryuser
   postgres -c "\l"
   Password for user primaryuser: password 
                           List of Databases
     Name    |  Owner   | Encoding  | Collate | Ctype |   Access privileges   
  -----------+----------+-----------+---------+-------+-----------------------
   postgres  | postgres | SQL_ASCII  | C       | C     | 
   template0 | postgres | SQL_ASCII | C       | C     | =c/postgres          +
             |          |           |         |       | postgres=CTc/postgres
   template1 | postgres | SQL_ASCII | C       | C     | =c/postgres          +
             |          |           |         |       | postgres=CTc/postgres
   userdb    | postgres | SQL_ASCII | C       | C     | =Tc/postgres         +
             |          |           |         |       | postgres=CTc/postgres+
             |          |           |         |       | testuser=CTc/postgres
   (4 rows)
   ```
   The password for the primaryuser is password. You can see this is set in
   the ConfigMap file.

## Configuration

If you need custom startup options, you can edit the ConfigMap file
(15-postgresd-configmap.yaml) with your desired PostgreSQL configuration
settings.

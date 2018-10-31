---
layout: guide
title: StorageOS Docs - MySQL
anchor: platforms
module: platforms/kubernetes/examples/mysql
---

# ![image](/images/docs/explore/mysqllogo.png) MySQL with StorageOS

MySQL is a popular SQL open source database for a wide range of popular
web-based applications including WordPress.

## MySQL and StorageOS

There are several benefits with deploying MySQL with StorageOS:

* Easy to setup, configure and maintain MySQL instances
* Instant, stateless MySQL application containers on demand
* Persistent, highly available storage to mount stateful database data

Before you start, ensure you have StorageOS installed and ready on a Kubernetes
cluster. [See our guide on how to install StorageOS on Kubernetes for more
information](https://docs.storageos.com/docs/platforms/kubernetes/install)

## Deploying MySQL on Kubernetes

1. You can find the latest files in the StorageOS example deployment repostiory
   ```bash
    git clone https://github.com/storageos/deploy.git storageos
   ```
   The interesting file in the MySQL folder is the Stateful Set definition.
   This file contains the VolumeClaim template that will dynamically provision
   storage, using the StorageOS storage class. This happens by having a volume
   mount declared with the same name as a Volume Claim.
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
1. Move into the MySQL examples folder and create the objects

   ```bash
   cd storageos
   kubectl create -f /deploy/k8s/examples/mysql
  ```

1. Confirm MySQL is up and running.

   ```bash
   kubectl get pods -w -l app=mysql
  ```

## Persistent storage

This demonstrates recovery of the MySQL database from another node after the
container has exited.

1. Kill the MySQL container.

   ```bash
   $ kubernetes kill mysql-dev
   mysql-dev
   $ kubernetes ps -a -f name=mysql
   CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                        PORTS               NAMES
   41b99204cabf        mysql               "kubernetes-entrypoint.sh"   6 minutes ago       Exited (137) 14 seconds ago                       mysql-dev
   ```

1. Log into another node using `exit` and `ssh`. Start a new MySQL container
   instance and mount the same StorageOS `mysqldata` volume.

   ```bash
   kubernetes run --name mysql-dev      \
   -v mysqldata:/var/lib/mysql      \
   --volume-driver=storageos        \
   -e MYSQL_ROOT_PASSWORD=storageos \
   -d mysql                         \
   --ignore-db-dir=lost+found
   ```

1. Connect to the MySQL container and connect to the testdb database.

   ```bash
   $ kubernetes exec -it mysql-dev bash
   root@771452bc98c2:/# MYSQL_PWD=storageos mysql -u root testdb
   mysql>
   ```

1. List the tables and confirm our table is still there

   ```bash
   mysql> show tables;
   +------------------+
   | Tables_in_testdb |
   +------------------+
   | fruit            |
   +------------------+
   1 row in set (0.00 sec)
   ```

1. Insert some more data to the table

   ```bash
   mysql> INSERT INTO fruit (id, inventory, quantity) \
   VALUES (NULL, 'Peaches', '117');
   
   Query OK, 1 row affected (0.04 sec)
   ```

1. Query the table

   ```bash
   mysql> SELECT * FROM fruit;
   +----+-----------+----------+
   | id | inventory | quantity |
   +----+-----------+----------+
   |  1 | Apples    |       99 |
   |  2 | Bananas   |      128 |
   |  3 | Oranges   |      337 |
   |  4 | Peaches   |      117 |
   +----+-----------+----------+
   4 rows in set (0.00 sec)
   ```

1. Quit

   ```bash
   mysql> quit;
   root@771452bc98c2:/# exit
   ```

## Configuration

If you need custom startup options, a MySQL custom configuration file can be
managed and mounted to `/etc/mysql/conf.d` inside the mysql container.

Alternatively, configuration options can be passed as flags to mysqld. This will
provide the added flexibility to customize the container without having to
maintain a `.cnf` file in a separate mount.  To get a full list of available
options, type `kubernetes run -it --rm mysql --verbose --help` from a terminal
window.

For more details on configuring and linking this container image please visit
the  [MySQL kubernetes Hub Repository](https://hub.kubernetes.com/_/mysql/).

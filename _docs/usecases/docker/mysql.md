---
layout: guide
title: StorageOS Docs - MySQL
anchor: usecases
module: usecases/docker/mysql
---

# ![image](/images/docs/explore/mysqllogo.png) MySQL with StorageOS

MySQL is a popular SQL open source database for a wide range of popular
web-based applications including WordPress.

## MySQL and StorageOS

There are several benefits with deploying MySQL with StorageOS:

* Easy to setup, configure and maintain MySQL instances
* Instant, stateless MySQL application containers on demand
* Persistent, highly available storage to mount stateful database data

Before you start, ensure you have StorageOS installed and ready on a Linux
cluster.

## Create a MySQL Volume

1. Create a 1GB volume called `mysqldata` in the default namespace.

   ```bash
   $ docker volume create --driver storageos --opt size=1 mysqldata
   mysqldata
   $ docker volume list
   DRIVER              VOLUME NAME
   storageos:latest    mysqldata
   ```

1. Run a MySQL container using the StorageOS volume driver.

   ```bash
   docker run --name mysql-dev       \
   -v mysqldata:/var/lib/mysql       \
   --volume-driver=storageos         \
   -e MYSQL_ROOT_PASSWORD=storageos  \
   -d mysql                          \
   --ignore-db-dir=lost+found        \
   --explicit_defaults_for_timestamp
   ```

   * After MySQL version 5.6 the `--ignore-db-dir=lost+found` parameter needs to
     be used to ignore the   presence of the UNIX lost+found directory when
     initialising the database.
   * The MySQL container image includes `EXPOSE 3306` making the default MySQL
     TCP port automatically available to linked containers.

1. Confirm MySQL is up and running.

   ```bash
   $ docker logs mysql-dev
   2017-04-11T15:27:49.296269Z 0 [Note] mysqld (mysqld 5.7.17) starting as process 1 ...
   ...
   ...
   2017-04-11T15:27:53.209024Z 0 [Note] mysqld: ready for connections.
   Version: '5.7.17'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server (GPL)
   ```

## Create a test database

1. Connect to MySQL container and run the mysql client.

   ```bash
   $ docker exec -it mysql-dev bash
   root@41b99204cabf:/# MYSQL_PWD=storageos mysql -u root
   mysql>
   ```

1. Create a database.

   ```bash
   mysql> create database testdb;
   Query OK, 1 row affected (0.01 sec)
   mysql> show databases;
   +--------------------+
   | Database           |
   +--------------------+
   | information_schema |
   | mysql              |
   | performance_schema |
   | sys                |
   | testdb             |
   +--------------------+
   5 rows in set (0.00 sec)
   ```

1. Connect to the testdb database

   ```bash
   mysql> use testdb
   Database changed
   ```

1. Create a table.

   ```bash
   mysql> CREATE TABLE fruit (id INT NOT NULL PRIMARY KEY AUTO_INCREMENT, inventory CHAR(25), quantity INT(7));
   Query OK, 0 rows affected (0.02 sec)
   ```

1. Add some data.

   ```bash
   mysql> INSERT INTO fruit (id, inventory, quantity) \
   VALUES (NULL, 'Apples', '99'),                     \
   (NULL, 'Bananas', '128'),                          \
   (NULL, 'Oranges', '337');

   Query OK, 3 rows affected (0.00 sec)
   Records: 3  Duplicates: 0  Warnings: 0

   mysql> SELECT * FROM fruit;
   +----+-----------+----------+
   | id | inventory | quantity |
   +----+-----------+----------+
   |  1 | Apples    |       99 |
   |  2 | Bananas   |      128 |
   |  3 | Oranges   |      337 |
   +----+-----------+----------+
   3 rows in set (0.00 sec)
   ```

1. Quit.

   ```bash
   mysql> quit;
   root@771452bc98c2:/# exit
   ```

## Persistent storage

This demonstrates recovery of the MySQL database from another node after the
container has exited.

1. Kill the MySQL container.

   ```bash
   $ docker kill mysql-dev
   mysql-dev
   $ docker ps -a -f name=mysql
   CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                        PORTS               NAMES
   41b99204cabf        mysql               "docker-entrypoint.sh"   6 minutes ago       Exited (137) 14 seconds ago                       mysql-dev
   ```

1. Log into another node using `exit` and `ssh`. Start a new MySQL container
   instance and mount the same StorageOS `mysqldata` volume.

   ```bash
   docker run --name mysql-dev      \
   -v mysqldata:/var/lib/mysql      \
   --volume-driver=storageos        \
   -e MYSQL_ROOT_PASSWORD=storageos \
   -d mysql                         \
   --ignore-db-dir=lost+found
   ```

1. Connect to the MySQL container and connect to the testdb database.

   ```bash
   $ docker exec -it mysql-dev bash
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
options, type `docker run -it --rm mysql --verbose --help` from a terminal
window.

For more details on configuring and linking this container image please visit
the  [MySQL Docker Hub Repository](https://hub.docker.com/_/mysql/).

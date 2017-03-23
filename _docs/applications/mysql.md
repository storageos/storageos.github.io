---
layout: guide
title: MySQL with StorageOS
anchor: applications
module: applications/mysql
---


# ![image](/images/docs/explore/mysqllogo.png) MySQL with StorageOS

MySQL is a popular SQL open source database for a wide range of popular web-based applications including WordPress.

## MySQL and StorageOS

There are several benefits with deploying MySQL with StorageOS:

* Easy to setup, configure and maintain MySQL instances
* Instant, stateless MySQL application containers on demand
* Persistent, highly available storage to mount stateful database data from

For this example we will demonstrate how to use the StorageOS volume driver plugin with the latest MySQL container image.

Before you start, please ensure you have StorageOS installed and ready on a Linux cluster - please refer to the *Installation Guide* for further details.

## Configuration

If you need custom startup options, a MySQL custom configuration file can be managed and mounted to `/etc/mysql/conf.d` inside the mysql container.

Alternatively, configuration options can be passed as flags to mysqld. This will provide the added flexibility to customize the container without having to maintain a `.cnf` file in a separate mount.  To get a full list of available options, type `docker run -it --rm mysql --verbose --help` from a terminal window.

## Create a MySQL Volume

1. The Dockerfile that builds the standard MySQL container image expects a single volume to mount to `/var/lib/mysql`.  The first step for the installation will be to create a persistent MySQL data volume before starting up the container.


2. Let's create a new 1GB volume called *mysqldata* from the *default* Storage volume pool using either the StorageOS CLI or the Docker CLI and give it a description of *mysql*.

   ```
   $ storageos cli volume create -name=mysqldata -size=1 -pool=default -description=mysql
   ```

   --or we can use the Docker CLI to create the volumes--

   ```
   $ docker volume create -d storageos --name mysqldata --opt size=1 --opt pool=default \
           --opt description=mysql
   ```

2. Result from the StorageOS CLI

   ```
   ==> name=mysqldata
   ==> description=mysql
   ==> size=1
   ==> pool=default
   ==> Created volume: mysqldata
   ```

3. List the new volumes using the Docker CLI

   ```
   $ docker volume list
   DRIVER              VOLUME NAME
   storageos           mysqldata
   ```

## Start a MySQL Container

1. To get the latest working MySQL container image up and running use the following Docker command.

   ```
   docker run --name mysql-dev -v mysqldata:/var/lib/mysql --volume-driver=storageos \
      -e MYSQL_ROOT_PASSWORD=storageos -d mysql --ignore-db-dir=lost+found
   ```

   >**Note**: The MySQL container image includes `EXPOSE 3306` making the default MySQL TCP port automatically available to linked containers

   >**Note**: After MySQL version 5.6 the `--ignore-db-dir=lost+found` parameter needs to be used to ignore the presence of the UNIX lost+found directory when initialising the database.

2. Confirm database is up and running

   ```
   $ docker logs mysql-dev

   Initializing database
   ...
   ...
   Database initialized
   Initializing certificates
   Generating a 2048 bit RSA private key
   ```

## Create New Database and Table

Let's use the `docker exec` command to run SLQ commands from inside the container.

1. Connect to MySQL container

   ```
   $ docker exec -it mysql-dev bash
   root@41b99204cabf:/# mysql -u root -p
   Enter password:

   mysql>
   ```

2. Create database

   ```
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

   mysql> use testdb;
   Database changed
   ```

3. Create table

   ```
   mysql> CREATE TABLE fruit (id INT NOT NULL PRIMARY KEY AUTO_INCREMENT, inventory CHAR(25), quantity INT(7));
   Query OK, 0 rows affected (0.02 sec)
   ```

4. Add some data

   ```
   mysql> INSERT INTO fruit (id, inventory, quantity) VALUES (NULL, 'Apples', '99'), (NULL, 'Bananas', '128'), (NULL, 'Oranges', '337');
   Query OK, 3 rows affected (0.00 sec)
   Records: 3  Duplicates: 0  Warnings: 0
   ```

5. Query data

   ```
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

6. Quit

   ```
   mysql> quit;
   root@771452bc98c2:/# exit
   ```

## Recover MySQL Database from Another Node

1. Kill our currently running MySQL container

   ```
   $ docker kill mysql-dev
   mysql-dev
   ```

2. Verify running status of container

   ```
   $ docker ps -a -f name=mysql
   CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                        PORTS               NAMES
   41b99204cabf        mysql               "docker-entrypoint.sh"   6 minutes ago       Exited (137) 14 seconds ago                       mysql-dev
   ```

3. Log into another node and start a new MySQL container instance and mount the same StorageOS mysqldata volume we created earlier

   ```
   $ docker run --name mysql-dev -v mysqldata:/var/lib/mysql --volume-driver=storageos \
        -e MYSQL_ROOT_PASSWORD=storageos -d mysql --ignore-db-dir=lost+found
   ```

4. Connect to the MySQL database

   ```
   $ docker exec -it mysql-dev bash
   root@771452bc98c2:/# mysql -u root -p
   Enter password:

   mysql>
   ```

5. List the tables and confirm our table is still there

   ```
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
   5 rows in set (0.01 sec)
   ```

6. Connect to the MySQL database

   ```
   mysql> use testdb
   ```

7. Insert some more data to the table

   ```
   mysql> INSERT INTO fruit (id, inventory, quantity) VALUES (NULL, 'Peaches', '117');
   Query OK, 1 row affected (0.04 sec)
   ```

8. Query the table

   ```
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

9. Quit

   ```
   mysql> quit;
   root@771452bc98c2:/# exit
   ```

## Further Reading

For more details on configuring and linking this container image please visit the  [MySQL Docker Hub Repository](https://hub.docker.com/_/mysql/ "MySQL Repository").

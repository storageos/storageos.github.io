---
layout: guide
title: PostgreSQL with StorageOS
anchor: applications
module: applications/postgres
---


# ![image](/images/docs/explore/postgresqllogo.png) PostgreSQL with StorageOS

PostgreSQL, or simply "Postgres", is an open source object-relational database management system (ORDBMS).

Postgres is deployed across a wide variety of platforms with a mix of workloads ranging from small, single-node use cases to large Internet-facing with many concurrent users.

For this exercise we will demonstrate how easily you can get Postgres up and running with StorageOS. <!--- and then explore some of the perfromance characteristics using the built-in Postgres benchmark tool PgBench --->

Before you start, please ensure you have StorageOS installed and ready on a Linux cluster - please refer to the *Installation Guide* for further details.

## Configuration

There are a number of optional paramaters that can be passed as environment variables - these are documented in more detail on the [Postgres Docker Hub Repository](https://hub.docker.com/_/postgres/ "Postgres Repository").

The StorageOS volume will appear to Postgres as a file system mountpoint and as a result the database will fail to initialise as the data directory will not appear empty because a lost+found directory will be present from the root.

Different SQL databases manage the lost+found directory in different ways.  For Postgres, we simply need to locate the data directory one level up from the StorageOS root volume using provided `PGDATA` environment variable with the following recommendations:

* Use the internal container path `/var/lib/postgresql` to mount the StorageOS `pgdata` volume to
* Set the environment variable `PGDATA` to `/var/lib/postgresql/data` for the internal container Postgres database path

## Create a Postgres Data Volume

1. The most effective way to create a volume is using the StorageOS CLI - for this example we'll create a 2GB volume called *pgdata* from the *default* StorageOS volume pool.

   ```
   $ storageos cli volume create -name=pgdata -size=2 -pool=default -description=postgres
   ```

2. Result from the StorageOS CLI

   ```
   ==> name=pgdata
   ==> description=postgres
   ==> size=2
   ==> pool=default
   ==> Created volume: pgdata
   ```

3. List the new volumes using the Docker CLI

   ```
   $ docker volume list
   DRIVER              VOLUME NAME
   storageos           pgdata
   ```

## Start a Postgres Container

1. To get the latest working Postgres container image up and running use the following Docker command

   ```
   $ docker run -d --name postgres-dev -v pgdata:/var/lib/postgresql/data --volume-driver=storageos \
         -e POSTGRES_PASSWORD=storageos -e PGDATA=/var/lib/postgresql/data/pgdata postgres
   ```

   >**Note**: The Postgres container image includes `EXPOSE 5432` making the default Postgres TCP port automatically available to linked containers

   >**Note**: As discussed earlier, the `PGDATA=` parameter needs to be used to work around the presence of the UNIX lost+found directory when initialising the database.

2. Confirm Postgres is up and running

   ```
   $ docker logs postgres-dev

   PostgreSQL init process complete; ready for start up.
   ...
   ...
   LOG:  database system is ready to accept connections
   LOG:  autovacuum launcher started
   ```

## Create a New Database and Table

Let's use the `docker exec` command to run Postgres CLI commands from inside the container.

1. Connect to Postgres container

   ```
   docker exec -it postgres-dev bash
   root@a0f7a1d3d753:/# psql -U postgres
   psql (9.6.2)
   Type "help" for help.

   postgres=#
   ```

2. Create a database

   ```
   postgres=# CREATE DATABASE testdb;
   CREATE DATABASE
   postgres=# \l
                                 List of databases
      Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
   -----------+----------+----------+------------+------------+-----------------------
    postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
    template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
              |          |          |            |            | postgres=CTc/postgres
    template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
              |          |          |            |            | postgres=CTc/postgres
    testdb    | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
   (4 rows)
   ```

## Connect and Create a Table

1. Connect to our testdb database

   ```
   postgres=# \c testdb;
   You are now connected to database "testdb" as user "postgres".
   testdb=#
   ```

2. Create a table

   ```
   CREATE TABLE FRUIT(
      ID INT PRIMARY KEY      NOT NULL,
      INVENTORY      CHAR(25) NOT NULL,
      QUANTITY       INT      NOT NULL
   );
   ```
3. Result

   ```
   testdb=# \d
         List of relations
   Schema | Name  | Type  |  Owner
   --------+-------+-------+----------
   public | fruit | table | postgres
   ```

## Add Some Data

1. Insert query

   ```
   testdb=# INSERT INTO FRUIT (ID,INVENTORY,QUANTITY) VALUES (1, 'Bananas', 132), (2, 'Apples', 165), (3, 'Oranges', 219);
   ```

2. Select query

   ```
   testdb=# SELECT * FROM FRUIT;
     1 | Bananas                   |      132
     2 | Apples                    |      165
     3 | Oranges                   |      219
   ```

6. Quit

   ```
   testdb=# \q
   root@a0f7a1d3d753:/# exit
   exit
   ```

## Recover Postgres Database from Another Node

1. Kill our currently running Postgres container

   ```
   $ docker kill postgres-dev
   postgres-dev
   ```

2. Verify running status of container

   ```
   $ docker ps -a -f name=postgres
   CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                        PORTS               NAMES
   a0f7a1d3d753        postgres            "docker-entrypoint.sh"   42 hours ago        Exited (137) 22 seconds ago                       postgres-dev
   ```

3. Log into another node and start a new MySQL container instance and mount the same StorageOS mysqldata volume we created earlier

   ```
   $ docker run -d --name postgres-dev -v pgdata:/var/lib/postgresql/data --volume-driver=storageos \
         -e POSTGRES_PASSWORD=storageos -e PGDATA=/var/lib/postgresql/data/pgdata postgres
   ```

4. Connect to the Postgres database

   ```
   $ docker exec -it postgres-dev bash
   root@bdea733192b7:/# psql -U postgres
   psql (9.6.2)
   Type "help" for help.
   ```

5. List the tables and confirm our table is still there

   ```
   postgres-# \l
                                 List of databases
      Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
   -----------+----------+----------+------------+------------+-----------------------
   postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
    template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
              |          |          |            |            | postgres=CTc/postgres
    template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
              |          |          |            |            | postgres=CTc/postgres
    testdb    | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
   (4 rows)
   ```

6. Connect to the testdb Postgres database

   ```
   postgres=# \c testdb
   You are now connected to database "testdb" as user "postgres"
   ```

7. Insert some more data to the table

   ```
   testdb=# INSERT INTO FRUIT (ID,INVENTORY,QUANTITY) VALUES (4, 'Peaches', 203);
   INSERT 0 1
   ```

8. Query the table

   ```
   testdb=# SELECT * FROM FRUIT;
    id |         inventory         | quantity
   ----+---------------------------+----------
     1 | Bananas                   |      132
     2 | Apples                    |      165
     3 | Oranges                   |      219
     4 | Peaches                   |      203
   (4 rows)
   ```

9. Quit

   ```
   testdb=# \q
   root@bdea733192b7:/# exit
   exit
   ```

<!---
## Performance Regression Testing with pgBench

Pgbench 9.0 is a simple tool for running benchmark tests on PostgreSQL. It runs a sequence of SQL commands concurrently using worker threads and calculates an average transaction rate per second loosely based on the old TPC-B benchmark.  This involves five SELECT, UPDATE, and INSERT commands per transaction.

>**Note**: Running `pgbench -i` creates four tables `pgbench_accounts`, `pgbench_branches`, `pgbench_history`, and `pgbench_tellers`, destroying any existing tables with these names.
--->

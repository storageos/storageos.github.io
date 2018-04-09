---
layout: guide
title: StorageOS Docs - PostgreSQL
anchor: applications
module: applications/postgres
# Last checked by cheryl.hung@storageos.com on 2017-04-10
---

# ![image](/images/docs/explore/postgresqllogo.png) PostgreSQL with StorageOS

PostgreSQL or "Postgres" is an open source object-relational database management
system (ORDBMS).

Postgres is deployed across a wide variety of platforms with a mix of workloads
ranging from small, single-node use cases to large Internet-facing with many
concurrent users.

Before you start, ensure you have StorageOS installed and ready on a Linux
cluster - please refer to the [quick start]({% link _docs/install/quickstart.md %})
guide for further details.

## Create a Postgres data volume

1. Create a 2GB volume called `pgdata`.

   ```bash
   $ docker volume create --driver storageos --opt size=2 pgdata
   pgdata
   $ docker volume ls
   DRIVER              VOLUME NAME
   storageos:latest    pgdata
   ```

1. Run a Postgres container using the StorageOS volume driver.

   ```bash
   $ docker run -d --name postgres-dev \
   --volume-driver=storageos \
   -v pgdata:/var/lib/postgresql/data \
   -e PGDATA=/var/lib/postgresql/data/pgdata \
   -e POSTGRES_PASSWORD=storageos postgres
   a9a77832df4e0b220ca6c0184f8e2e2ce933a6cdfa83ba2a2810243c7bf0e53c
   ```

   * The StorageOS volume appears as a file system mount, so we need to mount the
     `pgdata` volume to the internal container path `/var/lib/postgresql/data`, and
     set the environment variable `PGDATA` to the `/var/lib/postgresql/data/pgdata`
     subdirectory. See [Postgres docs](https://hub.docker.com/_/postgres/).
   * The Postgres container image includes `EXPOSE 5432` making the default
     Postgres TCP port automatically available to linked containers.

1. Confirm Postgres is up and running.

   ```bash
   $ docker logs postgres-dev
   PostgreSQL init process complete; ready for start up.
   ...
   ...
   LOG:  database system is ready to accept connections
   LOG:  autovacuum launcher started
   ```

## Create a test database

1. Connect to the Postgres container.

   ```bash
   $ docker exec -it postgres-dev bash
   root@a0f7a1d3d753:/# psql -U postgres
   psql (9.6.2)
   Type "help" for help.
   postgres=#
   ```

1. Create a database and connect to it.

   ```bash
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
   postgres=# \c testdb;
   You are now connected to database "testdb" as user "postgres".
   testdb=#
   ```

1. Create a table.

   ```bash
   testdb=# CREATE TABLE FRUIT(
     ID INT PRIMARY KEY      NOT NULL,
     INVENTORY      CHAR(25) NOT NULL,
     QUANTITY       INT      NOT NULL
   );
   CREATE table
   testdb=# \d
          List of relations
   Schema | Name  | Type  |  Owner
   --------+-------+-------+----------
   public | fruit | table | postgres
   (1 row)
   ```

1. Insert sample data.

   ```bash
   testdb=# INSERT INTO FRUIT (ID,INVENTORY,QUANTITY) VALUES (1, 'Bananas', 132), (2, 'Apples', 165), (3, 'Oranges', 219);
   INSERT 0 3
   testdb=# SELECT * FROM FRUIT;
   id |         inventory         | quantity
   ----+---------------------------+----------
    1 | Bananas                   |      132
    2 | Apples                    |      165
    3 | Oranges                   |      219
   (3 rows)
   ```

1. Quit.

   ```bash
   testdb=# \q
   root@a0f7a1d3d753:/# exit
   exit
   ```

## Persistent storage

This demonstrates recovery of the postgres database from another node after the
container has exited.

1. Kill the Postgres container.

   ```bash
   $ docker kill postgres-dev
   postgres-dev
   $ docker ps -a -f name=postgres
   CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                        PORTS               NAMES
   a0f7a1d3d753        postgres            "docker-entrypoint.sh"   42 hours ago        Exited (137) 22 seconds ago                       postgres-dev
   ```

1. Log into another node using `exit` and `ssh`. Start a new Postgres container
   instance and mount the same StorageOS `pgdata` volume.

   ```bash
   docker run -d --name postgres-dev -v pgdata:/var/lib/postgresql/data --volume-driver=storageos \
       -e POSTGRES_PASSWORD=storageos -e PGDATA=/var/lib/postgresql/data/pgdata postgres
   ```

1. Connect to the Postgres database

   ```bash
   $ docker exec -it postgres-dev bash
   root@bdea733192b7:/# psql -U postgres
   psql (9.6.2)
   Type "help" for help.
   ```

1. Confirm the `testdb` database was persisted.

   ```bash
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

1. Connect to the `testdb` Postgres database.

   ```bash
   postgres=# \c testdb
   You are now connected to database "testdb" as user "postgres"
   ```

1. Insert some more data to the table.

   ```bash
   testdb=# INSERT INTO FRUIT (ID,INVENTORY,QUANTITY) VALUES (4, 'Peaches', 203);
   INSERT 0 1
   ```

1. Query the table.

   ```bash
   testdb=# SELECT * FROM FRUIT;
   id |         inventory         | quantity
   ----+---------------------------+----------
    1 | Bananas                   |      132
    2 | Apples                    |      165
    3 | Oranges                   |      219
    4 | Peaches                   |      203
   (4 rows)
   ```

1. Quit.

   ```bash
   testdb=# \q
   root@bdea733192b7:/# exit
   exit
   ```

<!---
## Performance Regression Testing with pgBench

Pgbench 9.0 is a simple tool for running benchmark tests on PostgreSQL. It runs
a sequence of SQL commands concurrently using worker threads and calculates an
average transaction rate per second loosely based on the old TPC-B benchmark.
This involves five SELECT, UPDATE, and INSERT commands per transaction.

>**Note**: Running `pgbench -i` creates four tables `pgbench_accounts`,
`pgbench_branches`, `pgbench_history`, and `pgbench_tellers`, destroying any
existing tables with these names.
--->

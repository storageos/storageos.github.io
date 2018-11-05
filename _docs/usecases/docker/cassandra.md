---
layout: guide
title: StorageOS Docs - Cassandra
anchor: usecases
module: usecases/docker/cassandra
---

# ![image](/images/docs/explore/cassandralogo.png) Cassandra with StorageOS

Apache Cassandra is a free and open-source distributed NoSQL database management system designed to handle large amounts of data across many commodity servers, providing high availability with no single point of failure.

## Cassandra and StorageOS

There are several benefits with deploying Cassandra instances as Docker
application containers with StorageOS:

* Create easy to maintain, configurable Cassandra instances
* Instant, stateless Cassandra application containers on demand
* Persistent, highly available storage to mount stateful database data

Before you start, ensure you have StorageOS installed and ready on a Linux
cluster.

## Create a Cassandra Volume

1. Create a 1GB volume called `cassandradata` in the default namespace.

   ```bash
   $ docker volume create --driver storageos --opt size=1 cassandradata
   cassandradata
   $ docker volume list
   DRIVER              VOLUME NAME
   storageos:latest    cassandradata
   ```

1. Run a Cassandra container using the StorageOS volume driver.

   ```bash
   docker run --name cassandra-dev -v cassandradata:/var/lib/cassandra --volume-driver=storageos -d cassandra
   ```

   * Note that the Cassandra container image includes `EXPOSE 9042` making the default Cassandra
     TCP port automatically available to linked containers.

1. Confirm Cassandra is up and running.

   ```bash
   $ docker logs cassandra-dev
   ...
   INFO  [main] 2017-09-07 19:50:10,026 Server.java:156 - Starting listening for CQL clients o
n /0.0.0.0:9042 (unencrypted)...
   ...
   INFO  [OptionalTasks:1] 2017-09-07 19:50:11,986 CassandraRoleManager.java:355 - Created def
ault superuser role 'cassandra'
   ```

## Create a test database

1. Start another Cassandra container instance and run `cqlsh` (Cassandra Query Language Shell) against your original Cassandra container.

   ```bash
   $ docker run -it --link cassandra-dev:cassandra --rm cassandra cqlsh cassandra
   Connected to Test Cluster at cassandra:9042.
   [cqlsh 5.0.1 | Cassandra 3.11.0 | CQL spec 3.4.4 | Native protocol v4]
   Use HELP for help.
   cqlsh>
   ```

1. Create a keyspace.

   ```bash
   cqlsh> CREATE KEYSPACE testkeyspace WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 };
   cqlsh> DESCRIBE KEYSPACE testkeyspace;

   CREATE KEYSPACE testkeyspace WITH replication = {'class': 'SimpleStrategy', 'replication_factor': '1'}  AND durable_writes = true;
   ```

1. Use to the testkeyspace database

   ```bash
   cqlsh> USE testkeyspace;
   cqlsh:testkeyspace>
   ```

1. Create a table.

   ```bash
   cqlsh:testkeyspace> CREATE TABLE IF NOT EXISTS users (user_id timeuuid PRIMARY KEY, added_date timestamp, first_name text, last_name text, email text);
   cqlsh:testkeyspace>
   ```

1. Add some data.

   ```bash
   cqlsh:testkeyspace> INSERT INTO users (user_id, added_date, first_name, last_name, email) VALUES (now(), toTimestamp(now()), 'John', 'Doe', 'jdoe@email.com');
   cqlsh:testkeyspace> SELECT first_name, last_name, email FROM users;

    first_name | last_name | email
   ------------+-----------+----------------
          John |       Doe | jdoe@email.com

   (1 rows)
   ```

1. Quit.

   ```bash
   cqlsh:testkeyspace> quit
   $
   ```

## Persistent storage

This demonstrates recovery of the Cassandra database from another node after the
container has exited.

1. Kill the Cassandra container.

   ```bash
   $ docker kill cassandra-dev
   cassandra-dev
   $ docker ps -a -f name=cassandra
   CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                        PORTS               NAMES
   e6dcabdc2d1d        cassandra           "docker-entrypoint.sh"   30 minutes ago       Exited (137) 14 seconds ago                       cassandra-dev
   ```

1. Log into another node using `exit` and `ssh`. Start a new Cassandra container
   instance and mount the same StorageOS `cassandradata` volume.

   ```bash
   docker run --name cassandra-dev -v cassandradata:/var/lib/cassandra --volume-driver=storageos -d cassandra
   ```

1. Connect to the Cassandra database using `cqlsh`.

   ```bash
   $ docker run -it --link cassandra-dev:cassandra --rm cassandra cqlsh cassandra
   Connected to Test Cluster at cassandra:9042.
   [cqlsh 5.0.1 | Cassandra 3.11.0 | CQL spec 3.4.4 | Native protocol v4]
   Use HELP for help.
   cqlsh>
   ```

1. Describe the testkeyspace keyspace to confirm it is still there

   ```bash
   cqlsh> DESCRIBE KEYSPACES;

   system_schema  system              testkeyspace
   system_auth    system_distributed  system_traces
   ```

1. Connect to the testkeyspace keyspace

   ```bash
   cqlsh> USE testkeyspace;
   cqlsh:testkeyspace>
   ```

1. Insert some more data to the table

   ```bash
   cqlsh:testkeyspace> INSERT INTO users (user_id, added_date, first_name, last_name, email) VALUES (now(), toTimestamp(now()), 'Jane', 'Roe', 'jroe@email.com');
   cqlsh:testkeyspace>
   ```

1. Query the table

   ```bash
   cqlsh:testkeyspace> SELECT first_name, last_name, email FROM users;

    first_name | last_name | email
   ------------+-----------+----------------
          Jane |       Roe | jroe@email.com
          John |       Doe | jdoe@email.com

   (2 rows)
   ```

1. Quit

   ```bash
   cqlsh:testkeyspace> quit
   $
   ```

## Configuration

When you start the cassandra container, you can adjust the configuration of the Cassandra instance by passing one or more environment variables on the docker run command line. More information on these environment variables can be found in the [Docker Hub Cassandra page](https://hub.docker.com/_/cassandra/).

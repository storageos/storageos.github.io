---
layout: guide
title: StorageOS Docs - Cassandra
anchor: usecases
module: usecases/docker/cassandra
---

# ![image](/images/docs/explore/cassandralogo.png) Cassandra with StorageOS:

Cassandra is a popular distributed NoSQL open source database. 

## Cassandra and StorageOS

There are several benefits with deploying Cassandra with StorageOS:

* Instant, stateless Cassandra application containers on demand
* Persistent, highly available storage for application and database data

Before you start, ensure you have StorageOS installed and ready on a Linux
cluster.

## Create a Cassandra Volume

1. Create a 1GB volume called `cassandra-data` in the default namespace for
   each Cassandra ring member. In this example we will have a three member ring so
   three volumes will be created. 

   ```bash
   $ docker volume create --driver storageos --opt size=1 cassandra-data
   cassandra-data
   $ docker volume create --driver storageos --opt size=1 cassandra-data2
   cassandra-data
   $ docker volume create --driver storageos --opt size=1 cassandra-data3
   cassandra-data
   
   $ docker volume list
   DRIVER              VOLUME NAME
   storageos           cassandra-data
   storageos           cassandra-data2
   storageos           cassandra-data3
   ```

1. Run a Cassandra container using the StorageOS volume driver.

   ```bash
   $ docker run -d --name cassandra-docker \
   -v cassandra-data:/var/lib/cassandra    \
   cassandra:3.11
   ```

   * The Cassandra container image automatically exposes the default Cassandra
     TCP ports for communication with other containers.

1. Confirm Cassandra is up and running.

   ```bash
   $ docker ps
   CONTAINER ID        IMAGE                  COMMAND                  CREATED             STATUS                PORTS                                         NAMES
   e701e4945fb6        cassandra:3.11         "docker-entrypoint.s…"   About an hour ago   Up About an hour      7000-7001/tcp, 7199/tcp, 9042/tcp, 9160/tcp   cassandra-docker
   ```

1. Run the other two Cassandra containers

   ```bash
    $ docker run -d --name cassandra-docker2 \
    -v cassandra-data2:/var/lib/cassandra    \
    -e CASSANDRA_SEEDS="$(docker inspect --format='{% raw %}{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}{% endraw %}' cassandra-docker)" \
    cassandra:3.11

    $ docker run -d --name cassandra-docker3 \
    -v cassandra-data3:/var/lib/cassandra    \
    -e CASSANDRA_SEEDS="$(docker inspect --format='{% raw %}{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}{% endraw %}' cassandra-docker)" \
    cassandra:3.11
   ```
1. Confirm that the cluster is working correctly
    ```bash
    $ docker exec -it cassandra-docker bash
    root@e701e4945fb6:/# nodetool status
    Datacenter: datacenter1
    =======================
    Status=Up/Down
    |/ State=Normal/Leaving/Joining/Moving
    --  Address     Load       Tokens       Owns (effective)  Host ID                               Rack
    UN  172.17.0.3  200.71 KiB  256          66.2%             e1313667-f07a-4c96-acb4-9cec76ee39cd  rack1
    UN  172.17.0.2  184.65 KiB  256          64.5%             c9e5b849-8b5c-4f2c-af88-e078d08ea1e1  rack1
    UN  172.17.0.4  172.88 KiB  256          69.3%             cbe970e9-3207-412b-916b-844a0123cf08  rack1
    ```

## Create a test database

1. Connect to Cassandra container and run the cassandra client.

   ```bash
   $ docker exec -it cassandra-docker cqlsh
    Connected to Test Cluster at 127.0.0.1:9042.
    [cqlsh 5.0.1 | Cassandra 3.11.3 | CQL spec 3.4.4 | Native protocol v4]
    Use HELP for help.
    cqlsh> SELECT cluster_name, listen_address FROM system.local;

     cluster_name | listen_address
    --------------+----------------
     Test Cluster |     172.17.0.2

    (1 rows)
   ```

## Configuration

For more details on configuring and linking this container image please visit
the [Cassandra Docker Hub Repository](https://hub.docker.com/_/cassandra/).

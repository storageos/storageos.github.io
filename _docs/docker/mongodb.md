---
layout: guide
title: StorageOS Docs - MongoDB
anchor: docker
module: docker/mongodb
---

# ![image](/images/docs/explore/mongologo.png) MongoDB with StorageOS

MongoDB is an open source NoSQL database.  Instead of using tables and rows it
is built on collections and documents.

## MongoDB and StorageOS

There are several benefits with deploying MongoDB instances as Docker
application containers with StorageOS:

* Create easy to maintain, configurable MongoDB instances
* Instant, stateless MongoDB application containers on demand
* Persistent, highly available storage to mount stateful database data

This guide demonstrates running MongoDB in a container with StorageOS. Before
starting, ensure you have StorageOS installed on a cluster.

## Create a MongoDB Data and Config Volume

The Dockerfile that builds the standard MongoDB container supports separate
volumes to point to `/data/db` and `/data/configdb` so we need to create two
separate persistent volumes for this exercise.  The best way to do this is
create the volumes first and then start up the container.

1. Create a 2GB volume called `mongodata` and a 1GB volume called `mongoconf`
   in the default namespace.

    ```bash
    $ docker volume create --driver storageos --opt fstype=xfs --opt size=2 mongodata
    mongodata
    $ docker volume create --driver storageos --opt fstype=xfs --opt size=1 mongoconf
    mongoconf
    $ docker volume list
    DRIVER              VOLUME NAME
    local               b75672a8fcad3720455c860e5a7ba22391639e1d7668ae66d756ea84381a9926
    storageos:latest    mongoconf
    storageos:latest    mongodata
    ```

1. Run a MongoDB container using the StorageOS volume driver.

    ```bash
    docker run --name mongo-dev -d -v mongodata:/data/db -v mongoconf:/data/configdb \
        --volume-driver=storageos mongo
    ```
    * Mongo logs will be available via `docker logs <container-name>`.
    * The MongoDB container image includes `EXPOSE 27017` making the default MongoDB TCP port automatically available to linked containers.

1. Connect to the Mongo container and create an admin user called `storageos`.

    ```bash
    $ docker exec -it mongo-dev mongo admin
    > db.createUser({ user: 'storageos', pwd: 'storageos', roles: \
        [{ role: "userAdminAnyDatabase", db: "admin" }] });
    ```

1. The following result tells us we were able to successfully create the new
   StorageOS user

   ```bash
   Successfully added user: {
      "user" : "storageos",
      "roles" : [
         {
            "role" : "userAdminAnyDatabase",
            "db" : "admin"
         }
      ]
   }
   ```

1. Exit the MongoDB shell session

    ```bash
    > quit();
    ```

1. Connect externally to the database

   ```bash
   docker run -it --rm --link mongo-dev:mongo mongo mongo -u storageos -p storageos \
       --authenticationDatabase admin mongo-dev/test-db
   ```

1. Populate some data to a test data collection

   ```bash
   > for (var i = 1; i <= 5; i++) {db.testData.insert( { x : i } ) };
   WriteResult({ "nInserted" : 1 });
   ```

1. Result

   ```bash
   WriteResult({ "nInserted" : 1 })
   ```

1. Query the data we just wrote so we know it's there

   ```bash
   > db.testData.find();
   { "_id" : ObjectId("58b84c68e3b28abdf727c539"), "x" : 1 }
   { "_id" : ObjectId("58b84c68e3b28abdf727c53a"), "x" : 2 }
   { "_id" : ObjectId("58b84c68e3b28abdf727c53b"), "x" : 3 }
   { "_id" : ObjectId("58b84c68e3b28abdf727c53c"), "x" : 4 }
   { "_id" : ObjectId("58b84c68e3b28abdf727c53d"), "x" : 5 }
   ```

1. Exit the MongoDB shell session

   ```bash
   > quit();
   ```

## Restart MongoDB on Another Node

1. Kill our currently running MongoDB container

   ```bash
   $ docker kill mongo-dev
   mongo-dev
   ```

1. Verify running status of container

   ```bash
   $ docker ps -a -f name=mongo
   CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                            PORTS               NAMES
   216c2e2e9635        mongo               "/entrypoint.sh mongo"   6 minutes ago       Exited (137) 20 seconds ago                           mongo-dev
   ```

1. Log into another node and start a new MongoDB container instance and bind to
   our StorageOS volumes mongodata and mongoconf

   ```bash
   $ docker run --name mongo-dev -d -v mongodata:/data/db -v mongoconf:/data/configdb \
        --volume-driver=storageos mongo
   ```

1. Verify running status of container

   >**Note**: We have a new container ID

   ```bash
   $ docker ps -a -f name=mongo
   CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                      NAMES
   8ee7fa38c94b        mongo               "/entrypoint.sh mongo"   23 minutes ago      Up 22 minutes       0.0.0.0:32768->27017/tcp   mongo-dev
   ```

1. Attach to existing database using previously used credentials

   ```bash
   docker run -it --rm --link mongo-dev:mongo mongo mongo -u storageos -p storageos \
        --authenticationDatabase admin mongo-dev/test-db
   ```

1. Query the data we previously wrote and verify we can read from the database

   ```bash
   > db.testData.find();
   { "_id" : ObjectId("58b84c68e3b28abdf727c539"), "x" : 1 }
   { "_id" : ObjectId("58b84c68e3b28abdf727c53a"), "x" : 2 }
   { "_id" : ObjectId("58b84c68e3b28abdf727c53b"), "x" : 3 }
   { "_id" : ObjectId("58b84c68e3b28abdf727c53c"), "x" : 4 }
   { "_id" : ObjectId("58b84c68e3b28abdf727c53d"), "x" : 5 }
   ```

1. Verify we can write more data

   ```bash
   > for (var i = 6; i <= 10; i++) {db.testData.insert( { x : i } ) };
   WriteResult({ "nInserted" : 1 });
   ```

1. Read back what we just wrote

   ```bash
   > db.testData.find();
   { "_id" : ObjectId("58b84c68e3b28abdf727c539"), "x" : 1 }
   { "_id" : ObjectId("58b84c68e3b28abdf727c53a"), "x" : 2 }
   { "_id" : ObjectId("58b84c68e3b28abdf727c53b"), "x" : 3 }
   { "_id" : ObjectId("58b84c68e3b28abdf727c53c"), "x" : 4 }
   { "_id" : ObjectId("58b84c68e3b28abdf727c53d"), "x" : 5 }
   { "_id" : ObjectId("58b84c68e3b28abdf727c53e"), "x" : 6 }
   { "_id" : ObjectId("58b84c68e3b28abdf727c53f"), "x" : 7 }
   { "_id" : ObjectId("58b84c68e3b28abdf727c540"), "x" : 8 }
   { "_id" : ObjectId("58b84c68e3b28abdf727c541"), "x" : 9 }
   { "_id" : ObjectId("58b84c68e3b28abdf727c542"), "x" : 10 }
   ```

1. Exit the MongoDB shell session

   ```bash
   > quit();
   ```

---
layout: guide
title: MongoDB with StorageOS
anchor: explore
module: explore/mongodb
---


# ![image](/images/docs/explore/mongologo.png) MongoDB with StorageOS

There are several benefits with deploying MongoDB instances as Docker application containers with StorageOS, namely:

* Create easy to maintain, configurable MongoDB instances
* Instant, stateless MongoDB application containers on demand
* Persistent, highly available storage to mount stateful database data

For this example we are going to demonstrate setting up a MongoDB container using the StorageOS volume driver plugin using the latest MongoDB container image.  For the latest details on configuring and linking this image please visit the  [Mongo Docker Hub Repository](https://hub.docker.com/_/mongo/ "MongoDB Repository").

There are a number of ways to get MongoDB started but for this exercise lets step through the process.

## Create a MongoDB Data and Config Volume

1. The Dockerfile that builds the standard MongoDB container image expects 2 volumes to point to  `/data/db` and `/data/configdb` so we need to create two separate persistent volumes for this exercise.  The best way to do this is create the volumes first and then start up the container.

2. Lets create a new 2GB volume called *mongodbdata* and a 1GB volume called *mongoconf* from the *default* Storage volume pool using either the StorageOS CLI  or the Docker CLI and give it a description of *mongodb*.  

   ```
   storageos cli volume create -name=mongodata -size=2 -pool=default -description=mongodb
   storageos cli volume create -name=mongoconf -size=1 -pool=default -description=mongodb
   ```

   --or we can use the Docker CLI to create the volumes--

   ```
   docker volume create -d storageos --name mongodata --opt size=2 --opt pool=default --opt description=mongodb
   docker volume create -d storageos --name mongoconf --opt size=1 --opt pool=default --opt description=mongodb
   ```

2. Result from the StorageOS CLI

   ```
   ==> name=mongodata
   ==> description=mongodb
   ==> size=2
   ==> pool=default
   ==> Created volume: mongodata
   ```

3. List the new volumes using the Docker CLI

   ```
   $ docker volume list
   DRIVER              VOLUME NAME
   storageos           mongodata
   storageos           mongoconf
   ```

## Start a MongoDB Container

1. To get the latest MongoDB container image up and running simply use the  Docker command below - if you need to specify a specific version, append the image name with a version tag, e.g. mongo:&lt;version&gt;

   >**Note**: WiredTiger is now the default storage driver and MongoDB therfore expects an XFS filesystem.  Until we add support for this as a volume parameter you will see a warning in the log files
   
   >**Note**: This MongoDB container image includes `EXPOSE 27017` making the default MongoDB TCP port automatically available to linked containers
   
   >**Note**: Mongo logs are not sent to `/var/log/mongodb` and instead go stdout and will be available via `docker logs <container-name>` command

   ```
   $ docker run --name mongo-dev -d -v mongodata:/data/db -v mongoconf:/data/configdb --volume-driver=storageos mongo
   ```

## Configure an Admin User

Before we demonstrate MongoDB we need to set up an initial admin user.

1. Connect to Mongo container

   ```
   $ docker exec -it mongo-dev mongo admin
   ```

2. Create StorageOS admin user

   ```
   > db.createUser({ user: 'storageos', pwd: 'storageos', roles: [{ role: "userAdminAnyDatabase", db: "admin" }] });
   ```

3. The following result tells us we were able to successfully create the new StorageOS user

   ```
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
 
 4. Exit the MongoDB shell session

    ```
    > quit();
    ```

5. Connect externally to the database

   ```
   $ docker run -it --rm --link mongo-dev:mongo mongo mongo -u storageos -p storageos --authenticationDatabase admin mongo-dev/test-db
   ```

6. Populate some data to a test data collection
   
   ```
   > for (var i = 1; i <= 5; i++) {db.testData.insert( { x : i } ) };
   WriteResult({ "nInserted" : 1 });
   ```

7. Result

   ```
   WriteResult({ "nInserted" : 1 })
   ```

7. Query the data we just wrote so we know it's there

   ```
   > db.testData.find();
   { "_id" : ObjectId("58b84c68e3b28abdf727c539"), "x" : 1 }
   { "_id" : ObjectId("58b84c68e3b28abdf727c53a"), "x" : 2 }
   { "_id" : ObjectId("58b84c68e3b28abdf727c53b"), "x" : 3 }
   { "_id" : ObjectId("58b84c68e3b28abdf727c53c"), "x" : 4 }
   { "_id" : ObjectId("58b84c68e3b28abdf727c53d"), "x" : 5 }
   ```

8. Exit the MongoDB shell session

   ```
   > quit();
   ```


## Restart MongoDB on Another Node

1. Kill our currently running MongoDB container

   ```
   $ docker kill mongo-dev
   mongo-dev
   ```

2. Verify running status of container

   ```
   $ docker ps -a -f name=mongo
   CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                            PORTS               NAMES
   216c2e2e9635        mongo               "/entrypoint.sh mongo"   6 minutes ago       Exited (137) 20 seconds ago                           mongo-dev
   ```

3. Log into another node and start a new MongoDB container instance and bind to our StorageOS volumes mongodata and mongoconf

   ```
   $ docker run --name mongo-dev -d -v mongodata:/data/db -v mongoconf:/data/configdb --volume-driver=storageos mongo
   ```

4. Verify running status of container

   >**Note**: We have a new container ID

   ```
   $ docker ps -a -f name=mongo
   CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                      NAMES
   8ee7fa38c94b        mongo               "/entrypoint.sh mongo"   23 minutes ago      Up 22 minutes       0.0.0.0:32768->27017/tcp   mongo-dev
   ```

5. Attach to existing database using previously used credentials

   ```
   docker run -it --rm --link mongo-dev:mongo mongo mongo -u storageos -p storageos --authenticationDatabase admin mongo-dev/test-db
   ```

6. Query the data we previously wrote and verify we can read from the database

   ```
   > db.testData.find();
   { "_id" : ObjectId("58b84c68e3b28abdf727c539"), "x" : 1 }
   { "_id" : ObjectId("58b84c68e3b28abdf727c53a"), "x" : 2 }
   { "_id" : ObjectId("58b84c68e3b28abdf727c53b"), "x" : 3 }
   { "_id" : ObjectId("58b84c68e3b28abdf727c53c"), "x" : 4 }
   { "_id" : ObjectId("58b84c68e3b28abdf727c53d"), "x" : 5 }
   ```

7. Verify we can write more data

   ```
   > for (var i = 6; i <= 10; i++) {db.testData.insert( { x : i } ) };
   WriteResult({ "nInserted" : 1 });
   ```

8. Read back what we just wrote

   ```
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

9. Exit the MongoDB shell session

   ```
   > quit();
   ```

---
layout: guide
title: Microsoft SQL Server with StorageOS
anchor: applications
module: applications/mssql
---


# ![image](/images/docs/explore/mssqllogo.png) Microsoft SQL Server 2016 with StorageOS

 Microsoft's latest SQL Server release represents a major update with availability for Linux platform support and support to run as a container.

## Linux Support

Microsoft state SQL Server for Linux runs with any supported Linux distribution.  To date we have only tested with Ubuntu 16.04 which we used for this document and Alpine Linux (which did not work).  Additional requirements include:
* Minimum of 4 GB of disk space 
* Minimum of 4 GB of RAM (has been tested to work with 3.25GB)

Starting with SQL Server vNext CTP 1.4, the SQL Server command-line tools are included in the Docker image. If you attach to the image with an interactive command-prompt, you can run the tools locally.

## More Information

More information on SQL Server for Linux is available on the [Microsoft SQL Server for Linux](https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-overview "Microsoft SQL Server for Linuxy") web page.

Before you start, please ensure you have StorageOS installed and ready on a Linux cluster - please refer to the [Cluster install ](../install/clusterinstall.html)section for further details.

## Install MS SQL Server with StorageOS

1. Startup the latest MS SQL Server container on a StorageOS node with a StorageOS persistent volume

   ```
   $ sudo docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=p@ssw0rd' -p 1433:1433 \
        --name mssql -v mssql:/var/opt/mssql --volume-driver=storageos \
        -d microsoft/mssql-server-linux
   ```

2. Confirm a StorageOS volume was created successfully

   ```
   $ sudo docker volume list
   DRIVER              VOLUME NAME
   storageos           mssqldata
   ```

3. Confirm SQL Server installation status

   ```
   $ sudo docker logs mssql | more
   ...
   2017-04-13 09:24:22.28 Server      Dedicated admin connection support was established for listening locally on port 1434.
   2017-04-13 09:24:22.28 spid17s     SQL Server is now ready for client connections. This is an informational message; no user action is required.
   ```

## Install SQL Server command-line tools on Linux

Sqlcmd is now included as part of the SQL Server container however command-line tools and can be installed separately.

Depending on your Linux distribution, the installation will vary - for more details please consult the [Microsft's website](https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup-tools).

## Create a Test Database

1. Connect to SQL Server

   >**Note**: We are using *localhost* in this example - if you are running this from a remote host you will need to specify the target server IP.

   If you have installed the SQL Server tools separately you can use `sqlcmd -S localhost -U SA -P p@ssw0rd` to connect, alternatively use the `docker exec` command to run directly from the container.  The steps that follow apply to both methods of connecting to SQL Server. 

   ``` 
   $ sudo docker exec -it mssql /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P p@ssw0rd 

   1> SELECT Name from sys.Databases;
   2> go
   Name
   --------------------------------------------------------------------------------------------------------------------------------
   master
   empdb
   model
   msdb

   (4 rows affected)
   1> create database testdb;
   2> go
   1> use testdb;
   2> go
   Changed database context to 'testdb'.
   1> create table inventory (id INT, name NVARCHAR(50), quantity INT);
   2> go
   1> INSERT INTO inventory VALUES (1, 'banana', 150);
   2> INSERT INTO inventory VALUES (2, 'orange', 154);
   3> go

   (1 rows affected)

   (1 rows affected)
   1> SELECT * FROM inventory WHERE quantity > 152;
   2> go
   id          name                                               quantity
   ----------- -------------------------------------------------- -----------
             2 orange                                                     154

   (1 rows affected)
   1> quit
   ```


## Fail SQL Server on Hosting Node

1. Kill MS SQL application container

   ```
   storageos-1:~$ sudo docker kill mssql
   ```

2. Confirm running state

   ```
   $ sudo docker ps -a -f name=mssql
   CONTAINER ID        IMAGE                          COMMAND                  CREATED             STATUS                       PORTS               NAMES
   a9982de2801f        microsoft/mssql-server-linux   "/bin/sh -c /opt/mssq"   12 minutes ago      Exited (137) 2 minutes ago                       mssql
   ```

## Recover MS SQL Database on Second Node

1. Start up a new application container

   ```
   $ sudo docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=p@ssw0rd' -p 1433:1433 \
        --name mssql -v mssql:/var/opt/mssqldata --volume-driver=storageos \
        -d microsoft/mssql-server-linux
   ```

## Open Database to Read and Write Rows

1. Load Database and List Rows

   ```
   $ sudo docker exec -it mssql /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P p@ssw0rd 
   1> use testdb
   2> go
   Changed database context to 'testdb'.
   1> SELECT * FROM inventory
   2> go
   id          name                                               quantity
   ----------- -------------------------------------------------- -----------
             1 banana                                                     150
             2 orange                                                     154

   (2 rows affected)
   ```

2. Add a new row

   ```
   1> INSERT INTO inventory VALUES (3, 'apple', 99);
   2> go

   (1 rows affected)
   1> SELECT * FROM inventory
   2> go
   id          name                                               quantity
   ----------- -------------------------------------------------- -----------
             1 banana                                                     150
             2 orange                                                     154
             3 apple                                                       99

   (3 rows affected)
   1> quit
   ```

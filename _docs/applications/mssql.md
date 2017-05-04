---
layout: guide
title: StorageOS Docs - Microsoft SQL Server
anchor: applications
module: applications/mssql
---


# ![image](/images/docs/explore/mssqllogo.png) Microsoft SQL Server 2016 with StorageOS

 Microsoft's latest SQL Server release represents a major update with availability for Linux platform support and support to run as a container.

## Linux Support

Microsoft SQL Server for Linux runs with any supported Linux distribution.  The recommended distribution for testing StorageOS is Ubuntu 16.04.  Additional requirements include:
* Minimum of 4 GB of disk space 
* Minimum of 4 GB of RAM (has been tested to work with 3.25GB)

## Install MS SQL Server with StorageOS

1. Startup the latest MS SQL Server container on a StorageOS node with a StorageOS persistent volume:

   ```
   $ sudo docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=p@ssw0rd' -p 1433:1433 \
        --name mssql -v mssql:/var/opt/mssql --volume-driver=storageos \
        -d microsoft/mssql-server-linux
   ```

2. Confirm a StorageOS volume was created successfully:

   ```
   $ sudo docker volume list
   DRIVER              VOLUME NAME
   storageos           mssqldata
   ```

3. Confirm SQL Server installation status:

   ```
   $ sudo docker logs mssql | more
   ...
   2017-05-04 11:05:10.80 Server      Dedicated admin connection support was established for listening locally on port 1434.
   2017-05-04 11:05:10.80 spid19s     SQL Server is now ready for client connections. This is an informational message; no user action is required.
   ```

## Create a Test Database

1. Connect to SQL Server:

   If you have installed the SQL Server tools separately you can use `sqlcmd -S <ip_address> -U SA -P p@ssw0rd` to connect from a remote server, alternatively use the `docker exec` command to run directly from the container.  The steps that follow apply to both methods of connecting to SQL Server. 

   ``` 
   $ sudo docker exec -it mssql /opt/mssql-tools/bin/sqlcmd -U SA -P p@ssw0rd 

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

1. Kill MS SQL application container:

   ```
   storageos-1:~$ sudo docker kill mssql
   ```

2. Confirm running state:

   ```
   $ sudo docker ps -a -f name=mssql
   CONTAINER ID        IMAGE                          COMMAND                  CREATED             STATUS                       PORTS               NAMES
   a9982de2801f        microsoft/mssql-server-linux   "/bin/sh -c /opt/mssq"   12 minutes ago      Exited (137) 2 minutes ago                       mssql
   ```

## Recover MS SQL Database on Second Node

1. Start up a new application container:

   ```
   $ sudo docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=p@ssw0rd' -p 1433:1433 \
        --name mssql -v mssql:/var/opt/mssqldata --volume-driver=storageos \
        -d microsoft/mssql-server-linux
   ```

## Open Database to Read and Write Rows

1. Load Database and List Rows:

   ```
   $ sudo docker exec -it mssql /opt/mssql-tools/bin/sqlcmd -U SA -P p@ssw0rd 
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

2. Add a new row:

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

## More Information

Starting with SQL Server 2017 CTP 2.0, the SQL Server command-line tools are included in the Docker image. If you attach to the image with an interactive command-prompt, you can run the tools locally.

More information on SQL Server for Linux is available on the [Microsoft SQL Server for Linux](https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-overview "Microsoft SQL Server for Linux") web page.

Before you start, ensure you have StorageOS installed and ready on a Linux cluster - please refer to the [Cluster install ](../install/clusterinstall.html)section for further details.
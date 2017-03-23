---
layout: guide
title: Microsoft SQL Server with StorageOS
anchor: applications
module: applications/mssql
---


# ![image](/images/docs/explore/mssqllogo.png) Microsoft SQL Server 2016 with StorageOS

 Microsoft's latest SQL Server release represents a major update with availability for Linux platform support as well support to run as a container.

## Linux Support

For Ubuntu, the Docker container requires Xenial 16.04, it will not run on older distributions however it will run on the StorageOS  Vagrant and ISO builds which are Xenial 16.04 based.

## More Information

More information on SQL Server for Linux is available on the [Microsoft SQL Server for Linux](https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-overview "Microsoft SQL Server for Linuxy") web page.

Before you start, please ensure you have StorageOS installed and ready on a Linux cluster - please refer to the *Installation Guide* for further details.

## Install MS SQL Server with StorageOS

1. Get the latest MS SQL Server Linux container up and running

   ```
   $ sudo docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=p@ssw0rd' -p 1433:1433 \
        --name mssqldata -v mssql:/var/opt/mssql --volume-driver=storageos \
        -d microsoft/mssql-server-linux
   ```

2. Confirm the volume was created successfully

   ```
   $ sudo docker volume list
   DRIVER              VOLUME NAME
   storageos           mssqldata
   ```

3. Confirm SQL Server installation status

   ```
   $ sudo docker logs mssql | more
   Configuring Microsoft(R) SQL Server(R)...
   Configuration complete.
   paltelemetry: Loading the directory /var/opt/mssql/.system/.system/telemetry failed. Errno [2]
   This is an evaluation version.  There are [172] days left in the evaluation period.
   2017-01-26 16:13:33.63 Server      Microsoft SQL Server vNext (CTP1.2) - 14.0.200.24 (X64)
       Jan 10 2017 19:15:28
       Copyright (C) 2016 Microsoft Corporation. All rights reserved.
       on Linux (Ubuntu 16.04.1 LTS)
   ```

## Install MS SQL Tools on Ubuntu

Sqlcmd is part of the SQL Server command-line tools, which are not installed automatically with SQL Server on Linux and not present in the container image.

1. Install MS SQL Server Xenial CLI Package

   ```
   $ curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
   $ curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list
   $ sudo apt-get update
   $ sudo apt-get install mssql-tools unixodbc-dev
   ```

2. Add Symbolic Links

   ```
   $ sudo ln -sfn /opt/mssql-tools/bin/sqlcmd-13.0.1.0 /usr/bin/sqlcmd
   $ sudo ln -sfn /opt/mssql-tools/bin/bcp-13.0.1.0 /usr/bin/bcp
   ```

3. Optional: Add MSSQL Tools to your Path

   ```
   $ echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
   $ echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
   $ source ~/.bashrc
   ```

## Create a Test Database

1. Connect to SQL Server using the sqlcmd CLI tool

   >**Note**: We are using *localhost* in this example - if you are running this from a remote host you will need to specify the target server IP.  For the Vagrant build for example, this will start from the IP address 10.205.103.2

   ```
   $ sqlcmd -S localhost -U SA -P p@ssw0rd
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
   $ sqlcmd -S 10.205.103.3 -U SA -P 'p@ssw0rd'
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

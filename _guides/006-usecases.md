---
layout: default
title: Use Cases
anchor: usecases

sections:
  -
    title: Using Kubernetes
    description: Kubernetes Use Cases
    module: usecases/kubernetes
    items:
      -
        title: Microsoft SQL Server
        description: Create a Microsoft SQL server StatefulSet with persistent storage
        module: usecases/kubernetes/mssql
      -
        title: MySQL
        description: Create a MySQL StatefulSet with persistent storage
        module: usecases/kubernetes/mysql
      -
        title: PostgreSQL
        description: Create a PostgreSQL StatefulSet with persistent storage
        module: usecases/kubernetes/postgres
      -
        title: Redis
        description: Create a Redis StatefulSet with persistent storage
        module: usecases/kubernetes/redis
      -
        title: Nginx
        description: Use an Nginx pod to exfiltrate data from StorageOS volumes
        module: usecases/kubernetes/nginx
      -
        title: Cassandra
        description: Create a Cassandra cluster with persistent storage
        module: usecases/kubernetes/cassandra
      -
        title: Backups
        description: Exfiltrate files from StorageOS volumes
        module: usecases/kubernetes/backups

  -
    title: Using Docker
    description: Docker Use Cases
    module: usecases/docker
    items:
      -
        title: Cassandra
        description: Setting up a Cassandra ring with persistent storage
        module: usecases/docker/cassandra
      -
        title: Microsoft SQL Server
        description: Setting up Microsoft SQL server with persistent storage
        module: usecases/docker/mssql
      -
        title: MySQL
        description: Setting up MySQL with persistent storage
        module: usecases/docker/mysql
      -
        title: PostgreSQL
        description: Setting up PostgreSQL with persistent storage
        module: usecases/docker/postgres
      -
        title: Redis
        description: Setting up Redis with persistent storage
        module: usecases/docker/redis
---

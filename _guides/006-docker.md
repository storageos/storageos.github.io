---
layout: default
title: Docker
anchor: Docker

sections:
  -
    title: Install
    description: Install
    module: docker/install
  -
    title: Provision volumes
    description: Provision volumes
    module: docker/provision-volumes
  -
    title: Applications
    description: Applications
    module: docker
    items:
      -
        title: MySQL
        description: Setting up MySQL with persistent storage.
        module: docker/mysql
      -
        title: PostgreSQL
        description: Setting up PostgreSQL with persistent storage.
        module: docker/postgres
      -
        title: Microsoft SQL Server
        description: Setting up Microsoft SQL with persistent storage.
        module: docker/mssql
      -
        title: Redis
        description: Setting up Redis with persistent storage.
        module: docker/redis
      -
        title: Cassandra
        description: Setting up Cassandra with persistent storage.
        module: docker/cassandra
  -
    title: Users and policies
    description: Creating and managing users
    module: docker/users
---

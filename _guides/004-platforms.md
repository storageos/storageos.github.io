---
layout: default
title: Platforms
anchor: platforms

sections:
  -
    title: Kubernetes
    description: Kubernetes
    module: platforms/kubernetes
    items:
      -
        title: Install - 1.10+
        description: Install on 1.10+
        module: platforms/kubernetes/install-1.10
      -
        title: Install - 1.8, 1.9
        description: Install on 1.8, 1.9
        module: platforms/kubernetes/install-1.8
      -
        title: Install - 1.7
        description: Install on 1.7 and prior
        module: platforms/kubernetes/install-1.7
      -
        title: Howto - Provision volumes
        description: Provision StorageClasses and PVCs
        module: platforms/kubernetes/provision-volumes
      -
        title: Howto - Monitor volumes
        description: Monitor volumes
        module: platforms/kubernetes/monitor
      -
        title: Howto - Add and remove nodes
        description: Add and remove nodes
        module: platforms/kubernetes/addnodes
      -
        title: Production deployment tips
        description: Production deployments
        module: platforms/kubernetes/production
  - title: OpenShift
    description: Openshift
    module: platforms/openshift
    items:
      -
        title: Install - 3.9+
        description: Install on 3.9+
        module: platforms/openshift/install-3.9
      -
        title: Install - 3.8
        description: Install on 3.8
        module: platforms/openshift/install-3.8
      -
        title: Install - 3.7 and prior
        description: Install on 3.7 and prior
        module: platforms/openshift/install-3.7
      -
        title: Provision volumes
        description: Provision volumes
        module: platforms/openshift/provision-volumes
  - title: Docker
    description: Docker
    module: platforms/docker
    items:
      -
        title: Install
        description: Install
        module: platforms/docker/install
      -
        title: Provision volumes
        description: Provision volumes
        module: platforms/docker/provision-volumes
      -
        title: Users and policies
        description: Creating and managing users
        module: platforms/docker/users
      -
        title: Examples - MySQL
        description: Setting up MySQL with persistent storage.
        module: platforms/docker/mysql
      -
        title: Examples - PostgreSQL
        description: Setting up PostgreSQL with persistent storage.
        module: platforms/docker/postgres
      -
        title: Examples - MSSQL
        description: Setting up Microsoft SQL with persistent storage.
        module: platforms/docker/mssql
      -
        title: Examples - Redis
        description: Setting up Redis with persistent storage.
        module: platforms/docker/redis
      -
        title: Examples - Cassandra
        description: Setting up Cassandra with persistent storage.
        module: platforms/docker/cassandra
  - title: Azure
    description: Azure
    module: platforms/azure
    items:
      - title: Install
        description: Install
        module: platforms/azure/install
---

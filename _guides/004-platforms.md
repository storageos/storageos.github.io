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
        title: Install
        description: Install K8S
        module: platforms/kubernetes/install
        subitems:
          - 
            title: 1.12
            description: Install on 1.12
            module: platforms/kubernetes/install/1.12
          - 
            title: 1.11
            description: Install on 1.10 and 1.11
            module: platforms/kubernetes/install/1.11
          - 
            title: 1.10 <br>
            description: Install on 1.10
            module: platforms/kubernetes/install/1.10
          -
            title: 1.9
            description: Install on 1.9
            module: platforms/kubernetes/install/1.9
          -
            title: 1.8
            description: Install on 1.8
            module: platforms/kubernetes/install/1.8
          -
            title: 1.7
            description: Install on 1.7 and prior
            module: platforms/kubernetes/install/1.7
      - 
        title: HowTo
        description: Examples for operations
        module: platforms/kubernetes/howto
        subitems:
          -
            title: Provision volumes
            description: Provision StorageClasses and PVCs
            module: platforms/kubernetes/howto/provision-volumes
      - 
        title: Troubleshooting
        description: Troubleshooting
        module: platforms/kubernetes/troubleshoot
        subitems:
          -
            title: Installation
            description: Troubleshooting installation
            module: platforms/kubernetes/troubleshoot/install
          -
            title: Volume Provisioning
            description: Troubleshooting volumes
            module: platforms/kubernetes/troubleshoot/volumes
      - 
        title: Best Practices
        description: Kubernetes best practices
        module: platforms/kubernetes/bestpractices
  - title: OpenShift
    description: Openshift
    module: platforms/openshift
    items:
      -
        title: Install
        description: Install on OpenShift
        module: platforms/openshift/install
        subitems:
          -
            title: 3.9+
            description: Install on 3.9+
            module: platforms/openshift/install/3.9
          -
            title: 3.8
            description: Install on 3.8
            module: platforms/openshift/install/3.8
          -
            title: 3.7 and prior
            description: Install on 3.7 and prior
            module: platforms/openshift/install/3.7
      -
        title: HowTo
        description: Examples for operations
        module: platforms/openshift/howto
        subitems:
          -
            title: Provision volumes
            description: Provision volumes
            module: platforms/openshift/howto/provision-volumes
      - 
        title: Troubleshooting
        description: Troubleshooting
        module: platforms/openshift/troubleshoot
        subitems:
          -
            title: Installation
            description: Troubleshooting installation
            module: platforms/openshift/troubleshoot/install
          -
            title: Volume Provisioning
            description: Troubleshooting volumes
            module: platforms/openshift/troubleshoot/volumes
      - 
        title: Best Practices
        description: OpenShift best practices
        module: platforms/openshift/bestpractices
  - title: Docker
    description: Docker
    module: platforms/docker
    items:
      -
        title: Install
        description: Install
        module: platforms/docker/install
      -
        title: Users and policies
        description: Creating and managing users
        module: platforms/docker/users
      -
        title: Use cases
        description: Application examples
        module: platforms/docker/examples
        subitems:
          -
            title: MySQL
            description: Setting up MySQL with persistent storage.
            module: platforms/docker/examples/mysql
          -
            title: PostgreSQL
            description: Setting up PostgreSQL with persistent storage.
            module: platforms/docker/examples/postgres
          -
            title: MSSQL
            description: Setting up Microsoft SQL with persistent storage.
            module: platforms/docker/examples/mssql
          -
            title: Redis
            description: Setting up Redis with persistent storage.
            module: platforms/docker/examples/redis
          -
            title: Cassandra
            description: Setting up Cassandra with persistent storage.
            module: platforms/docker/examples/cassandra
      - 
        title: Troubleshooting
        description: Troubleshooting
        module: platforms/docker/troubleshoot
        subitems:
          -
            title: Installation
            description: Troubleshooting installation
            module: platforms/docker/troubleshoot/install
          -
            title: Volume Provisioning
            description: Troubleshooting volumes
            module: platforms/docker/troubleshoot/volumes
---

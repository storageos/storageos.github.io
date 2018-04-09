---
layout: default
title: Install and run
anchor: install

sections:
  -
    title: Quick start
    description: Quick start
    module: install/quickstart
  -
    title: Prerequisites
    description: Prerequisites
    module: install/prerequisites
    items:
      -
        title: Install CLI
        description: Install CLI
        module: install/cli
      -
        title: Cluster discovery
        description: Cluster discovery
        module: install/prerequisites/clusterdiscovery
      -
        title: Device presentation
        description: Device presentation
        module: install/prerequisites/devicepresentation
      -
        title: Ports and firewall settings
        description: Ports and firewall settings
        module: install/prerequisites/firewalls
  -
    title: Kubernetes
    description: Installing on Kubernetes
    module: install/kubernetes
    items:
      -
        title: Preprovisioned volumes
        description: Preprovisioned volumes
        module: install/kubernetes/preprovisioned
      -
        title: Dynamic provisioning
        description: Dynamic provisioning
        module: install/kubernetes/dynamic-provisioning
  -
    title: OpenShift
    description: Installing on OpenShift
    module: install/schedulers/openshift        
  -
    title: Docker
    description: Installing on Docker
    module: install/docker
    items:
      -
        title: Docker Swarm
        description: Installing on Docker Swarm
        module: install/docker/swarm
  -
    title: Cluster health
    description: Checking the status of a StorageOS cluster
    module: install/health
  -
    title: Troubleshooting
    description: Troubleshooting a Docker installation
    module: install/troubleshooting
---

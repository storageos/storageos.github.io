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
    title: Install CLI
    description: Install CLI
    module: install/installcli
  -
    title: Prerequisites
    description: Prerequisites
    module: install/prerequisites
    items:
      -
        title: Cluster Discovery
        description: Cluster Discovery
        module: install/prerequisites/clusterdiscovery
      -
        title: Device Presentation
        description: Device Presentation
        module: install/prerequisites/devicepresentation
      -
        title: Ports and Firewall Settings
        description: Ports and Firewall Settings
        module: install/prerequisites/firewalls
  -
    title: Docker Container
    description: Docker container install for Docker Engine 1.10+
    module: install/docker/container
  -
    title: Docker Volume plugin
    description: Docker managed plugin install for Docker Engine 1.13+
    module: install/docker/plugin
  -
    title: Docker Swarm
    description: Installing on Docker Swarm
    module: install/schedulers/dockerswarm
  -
    title: Kubernetes
    description: Installing on Kubernetes
    module: install/schedulers/kubernetes
  -
    title: OpenShift
    description: Installing on OpenShift
    module: install/schedulers/openshift
  -
    title: Cluster health
    description: Checking the status of a StorageOS cluster
    module: install/health
  -
    title: Troubleshooting
    description: Troubleshooting a Docker installation
    module: install/troubleshooting
---

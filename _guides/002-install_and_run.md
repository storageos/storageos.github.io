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
    title: Docker
    description: Docker
    module: install/docker
    items:
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
    title: Schedulers
    description: Running StorageOS using schedulers
    module: install/schedulers
    items:
      -
        title: Kubernetes
        description: Installing on Kubernetes
        module: install/schedulers/kubernetes
      -
        title: OpenShift
        description: Installing on OpenShift
        module: install/schedulers/openshift
      -
        title: Docker Swarm
        description: Installing on Docker Swarm
        module: install/schedulers/dockerswarm
      -
        title: Rancher
        description: Installing on Rancher
        module: install/schedulers/rancher
      -
        title: Mesophere DC/OS
        description: Installing on Mesosphere DC/OS
        module: install/schedulers/mesosphere-dcos
  -
    title: Cloud providers
    description: Running StorageOS on cloud providers
    module: install/cloud
    items:
      -
        title: AWS
        description: Installing on AWS
        module: install/cloud/aws
      -
        title: Azure
        description: Installing on Azure
        module: install/cloud/azure
      -
        title: Google Cloud
        description: Installing on Google Cloud
        module: install/cloud/googlecloud
  -
    title: Cluster health
    description: Checking the status of a StorageOS cluster
    module: install/health
  -
    title: Troubleshooting
    description: Troubleshooting a Docker installation
    module: install/troubleshooting
---

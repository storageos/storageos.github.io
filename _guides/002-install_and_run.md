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
        title: Key/Value Store
        description: Key/Value Store
        module: install/prerequisites/kvstore
      -
        title: Cluster discovery
        description: Cluster discovery
        module: install/prerequisites/clusterdiscovery
      -
        title: Network Block Device
        description: Network Block Device
        module: install/prerequisites/nbd
      -
        title: Troubleshooting
        description: Troubleshooting
        module: install/prerequisites/troubleshooting
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
        title: Rancher
        description: Installing on Rancher
        module: install/schedulers/rancher
      -
        title: Mesophere DC/OS
        description: Installing on Mesosphere DC/OS
        module: install/schedulers/mesosphere-dcos
  -
    title: Docker only
    description: Docker
    module: install/docker
    items:
      -
        title: Volume plugin
        description: Docker managed plugin install for Docker Engine 1.13+
        module: install/docker/plugin
      -
        title: Container
        description: Docker container install for Docker Engine 1.10+
        module: install/docker/container
      -
        title: Troubleshooting
        description: Troubleshooting a Docker installation
        module: install/docker/troubleshooting
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
---

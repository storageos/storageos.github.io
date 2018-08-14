---
layout: default
title: Kubernetes
anchor: kubernetes

sections:
  -
    title: Install on 1.10+
    description: Install on 1.10+
    module: kubernetes/install-1.10
  -
    title: Install on 1.8, 1.9
    description: Install on 1.8, 1.9
    module: kubernetes/install-1.8
  -
    title: Install on 1.7
    description: Install on 1.7 and prior
    module: kubernetes/install-1.7
  -
    title: Provision volumes
    description: Provision StorageClasses and PVCs
    module: kubernetes/provision-volumes
  -
    title: Production deployments
    description: Production deployments
    module: kubernetes/production
    items:
      -
        title: Monitor volumes
        description: Monitor volumes
        module: kubernetes/monitor
      -
        title: Add and remove nodes
        description: Add and remove nodes
        module: kubernetes/addnodes
      -
        title: Backups and upgrades
        description: Backups and upgrades
        module: kubernetes/backups
---

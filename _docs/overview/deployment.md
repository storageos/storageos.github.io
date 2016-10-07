---
layout: guide
title: Deployment Options
anchor: overview
module: overview/deployment
---

# Deployment Options

There are multiple deployment options to suit different environments.

## Number of Controllers

You can deploy StorageOS as a single-node or as multiple-node cluster:

* In a single-node deployment, most HA functionality (e.g. failover, replication) is not available.

* Multiple-node clusters synchronize support volume replication and automatic failover upon node or volume failure.

We do not yet have recommendations on the practical maximum cluster members, but are very interested in hearing from you about what works well (and what does not) in your environment. The design does not impose any constraints (i.e., maximum number, or odd number).

:warning: In the ISO-based deployment, Consul is bundled to store configuration data. Consul requires an odd number of nodes, so we recommend that ISO-based clusters have 3, 5, or 7 nodes.

## Hyper-converged, Dedicated, or Mixed-mode



## Deployment Method
StorageOS offers the following deployment options:
1. ISO-based single node client/server (using ISO to deploy both the control plane and data plane in one VM or physical machine with Docker and dependencies integrated in a single Ubuntu image.
2. ISO-based multi-node HA server with a client running on each server and containers deployed on the same node as StorageOS for lowest latency.
3. ISO-based multi-node HA server with a remote client container installation (to integrate with an existing Docker environment running on VMWare)
4. Container-based installation into existing an Docker environment (available for GA).
4. Automated Kubernetes-driven installation for an existing Kubernetes environment (available for GA).
5. Vagrant-based developer edition for VirtualBox.

This documentation covers deployment types 1 through 3. Live cluster expansion is a manual process that StorageOS will assist with today. We will automated that process for GA. The easiest ways to test StorageOS is to use option 1 or 2 because the entire process is fully automated. If you want to test option 3, refer to the __*StorageOS Stand Alone Client Installation Guide*__. To test the Vagrant installation, contact StorageOS for assistance.

**Note**: This is a Beta version of the software. Do NOT, under any circumstances, use this version for production. You should assume that any data stored on this storage array is non-essential test data and may be lost at any time. We are testing a zero downtime, data-in-place upgrade processes now, and this feature will be ready for GA. Until this is ready, assume upgrades may require that you redeploy the product restore data.

---
layout: guide
title: Deployment Options
anchor: overview
module: overview/deployment
---

# Deployment Options

There are multiple deployment options to suit different environments.

## Number of Controllers

StorageOS can be deployed as a single-node or as multiple-node cluster.

In a single-node deployment, most HA functionality (e.g. failover, replication) will not be available.

Multiple-node clusters will synchronous support volume replication and automatic failover on node or volume failure.

We do not yet have recommendations on the practical maximum cluster members, but are very interested to hear from the community what works well (and what doesn't).  The design does not impose any constraints, i.e. maximum number, or odd number.

:warning: In the ISO-based deployment, Consul is bundled to store configuration data.  Consul requires an odd number of nodes, so we recommend that ISO-based clusters have 3, 5 or 7 nodes.

## Hyper-converged, Dedicated, or Mixed-mode



## Deployment Method

1. ISO Based Single node Client/Server (using ISO to deploy both Control Plane and Data Plane in one VM or Physical machine with Docker and dependencies integrated in a single Ubuntu image.
2. ISO Based Multi-Node HA server with client running on each server and containers deployed on the same node as StorageOS for lowest latency.
3. ISO Based Multi-Node HA server with remote client container install (to integrate with an existing Docker Environment running on VMWare)
Container based install into existing Docker Environment (available for GA).
4. Automated Kubernetes driven install for existing Kubernetes environment (available for GA) .
5. Vagrant based developer edition for VirtualBox.

This documentation covers deployment types 1-3. Live cluster expansion is a manual process that StorageOS will assist with today, but this will be automated for GA. The easiest ways to test StorageOS are options 1 or 2 as the entire process is fully automated. If you want to test option 3, please see StorageOS Stand Alone Client Installation Guide. If you want to test the Vagrant install, please contact StorageOS.


Please note, this is a Beta version of the software, so should NOT be used for production under any circumstances. Any data stored on this storage array should assumed to be non-essential test data only and may be lost. We are testing a zero downtime, data-in-place upgrade processes now, and this feature will be ready for GA. Until this is ready, assume upgrades may require re-deployment of the product and backup and restore of data.

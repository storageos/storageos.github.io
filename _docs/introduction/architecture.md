---
layout: guide
title: Architecture Overview
anchor: introduction
module: introduction/architecture
---

# Architecture Overview

A StorageOS cluster comprises three or more controllers, and one or more optional clients where:

* Controllers unlock available compute storage (local or DAS), remote storage (object, SAN or NAS) and aggregates this into to a distributed pool presenting virtual block devices to clients through the StorageOS volume plugin.

* Clients direct virtual block devices from Controller nodes and do not contribute capacity to the StorageOS cluster.  As with the Controller, the Docker daemon running on Clients interfaces with the StorageOS volume plug-in to present storage to containers.

## Components
Controllers run both the control plane and the data plane components and clients run only the Docker plug-in and a subset of the data plane.  All components however are included within the same container and roles are defined using different run-time parameters.

### Data plane
The data plane processes all data access requests and pools the aggregated storage for presentation to Clients.  Because the data plane changes infrequently and any restarts interrupt service, the data plane starts as a separate container process.

### Control plane
The control plane is responsible for monitoring health and scheduling.  It does this through the StorageOS API which is called by the Docker plug-in, StorageOS Web UI, or CLI and in turn communicates with other nodes in the cluster to take the appropriate action.

The control plane is also responsible for maintaining state and does this over an embedded message bus (NATS) where configuration state is maintained in a distributed Key/Value store.  A rules engine acts on state changes and a scheduler determines the best placement.



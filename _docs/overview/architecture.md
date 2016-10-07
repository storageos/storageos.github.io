---
layout: guide
title: Architecture Overview
anchor: overview
module: overview/architecture
---

# Architecture Overview

## Deployment types

A StorageOS deployment consists of one or more controllers, and one or more optional clients.

 - Controllers take storage capacity from raw disks (local or attached), or remote (e.g., S3-based object stores), adds it to a distributed capacity pool, and then uses the capacity from the pool to present virtual block devices to clients. Controllers run both the **control plane** and the **data plane** components.

 - Clients consume the virtual block devices.  The Docker daemon running on a client interacts with the Docker plugin to present storage to the local containers.

Controllers and Clients can run on separate servers or on the same server in a hyper-converged deployment. You can make storage available to containers running on the controllers or on clients, but you can only add storage capacity (e.g. raw disks, cloud volumes) to controllers.

## Components
Controllers run both the control plane and the data plane components, and clients run only the Docker plugin and a subset of the data plane. All components are bundled within the same container and are selected using different runtime parameters.

### Data plane
The data plane processes all data access requests, and pools backend storage for presentation to clients. Because the data plane changes infrequently and all restarts interrupt service, it starts as a separate container process.

### Control plane
The control plane configures and schedules activity.   

The API handles direct requests or requests from the Docker plugin, the Web UI, or the CLI and communicates with other nodes in the cluster to take the appropriate action. It also stores state, monitors health, and takes action on state changes.  

Controller nodes communicate state changes with each other using an embedded message bus (NATS).

Configuration state is stored in an distributed Key/Value store (currently Consul, with Etcd support coming).  The StorageOS ISO installs Consul on each controller, which requires that ISO-based clusters have an odd number of members (1, 3 or 5 controllers recommended).  This restriction is lifted when an external KV Store is used instead.

A rules engine acts on state changes and a scheduler determines the best placement.

## Client

The client must be run on nodes that only require access to StorageOS volumes and do not contribute capacity to the StorageOS cluster.  In a client-only deployment, only the Docker plugin and a subset of the data plane components run.  The client must be configured with the address of the StorageOS cluster it will participate in.

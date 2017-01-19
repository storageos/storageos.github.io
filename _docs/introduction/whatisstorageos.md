---
layout: guide
title: What is StorageOS?
anchor: introduction
module: introduction/whatisstorageos
---

# What is StorageOS?

StorageOS is an enterprise class Software Defined Storage (SDS) solution optimised for, but not limited to, container-based workloads.  StorageOS works by leveraging the available storage in servers, virtual machines and cloud instances, aggregating and presenting this back as scalable, fully featured software defined enterprise storage.  In doing so, StorageOS ensures data is made portable, persistent, and stored securely and efficiently.

Importantly, StorageOS provides access to persistent data from within containers.  It does this independently of where the application container is running or is re-scheduled.  Regardless of what actions are taken on the application container, the storage will always be there!

StorageOS has been built using modern tools and design methodologies to meet the demands of modern infrastructure and workflows allowing application owners to seamlessly provision and manage their data around rapid development cycles.

StorageOS can be deployed to bare-metal, virtual machines, cloud, or Docker-based infrastructure.  It is designed from the ground up for automation.  Management is simple using an easy to use API, CLI and Web-based UI.  It is available as a free developer tier and pay-as-you-go for beyond 1TB capacities and for enterprise features.

![image](/images/docs/started/storageosinfra.png)

## Why use Containers?

Containerisation or Microservices are arguably the next big wave of disruption in technology infrastructure since VMware and virtualisation.

A container comprises an entire runtime environment for an application with all its dependencies in a single package.  By containerising applications, a hosting platform and its dependencies will not run the risk of interfering with application dependencies.

Compared to virtualisation, containers are quick to deploy and tear-down.  Additionally, containers are lightweight allowing more (applications) to be hosted on the same server than would be possible using VMs and at the same time, removing the management overhead of maintaining multiple Operating Systems (OSs) on a single server.

Being highly portable, containers can be deployed to a variety of public and private cloud infrastructures accelerating test and development cycles and as such, are well suited to Continuous Integration, Continuous Delivery (CI-CD) environments.

![image](/images/docs/started/containers.png)

## How does StorageOS add Value?

StorageOS helps developers move from *host-centric* infrastructure to a more abstracted *container-centric* infrastructure, providing the storage features required to take full advantage of the benefits inherent to containers.

StorageOS satisfies a number of common features for applications running in production, including:

| Feature                         |      Developer      |    Professional     |  |Feature                          |      Developer      |    Professional     |
|:--------------------------------|:-------------------:|:-------------------:|:-|:--------------------------------|:-------------------:|:-------------------:|
| **Data Reduction**              |                     |                     |  | **Data Protection**             |                     |                     |
|   ▪︎ Compression                 | {% icon fa-check %} | {% icon fa-check %} |  |   ▪︎ Erasure Coding              | {% icon fa-check %} | {% icon fa-check %} |
|   ▪︎ De-duplication              | {% icon fa-check %} | {% icon fa-check %} |  |   ▪︎ Advanced Erasure Coding     | {% icon fa-times %} | {% icon fa-check %} |
| **Data Run-Time Management**    |                     |                     |  |   ▪︎ In-Cluster Replicas         | {% icon fa-times %} | {% icon fa-check %} |
|   ▪︎ Resizing, Thin Provisioning | {% icon fa-check %} | {% icon fa-check %} |  | **Acceleration**                |                     |                     |
|   ▪︎ Snapshots                   | {% icon fa-times %} | {% icon fa-check %} |  |   ▪︎ SSD Optimized               | {% icon fa-check %} | {% icon fa-check %} |
|   ▪︎ Cloning                     | {% icon fa-times %} | {% icon fa-check %} |  |   ▪︎ Run alongside container     | {% icon fa-check %} | {% icon fa-check %} |
| **Front-end Connectivity**      |                     |                     |  |   ▪︎ Auto-configuration          | {% icon fa-check %} | {% icon fa-check %} |
|   ▪︎ Native connectivity         | {% icon fa-check %} | {% icon fa-check %} |  |   ▪︎ Caching                     | {% icon fa-times %} | {% icon fa-check %} |
|   ▪︎ iSCSI                       | {% icon fa-check %} | {% icon fa-check %} |  |   ▪︎ Scale-Out                   | {% icon fa-times %} | {% icon fa-check %} |
| **Supported Platforms**         |                     |                     |  | **Management**                  |                     |                     |
|   ▪︎ Linux containers            | {% icon fa-check %} | {% icon fa-check %} |  |   ▪︎ Restful API                 | {% icon fa-check %} | {% icon fa-check %} |
|   ▪︎ Bare metal                  | {% icon fa-check %} | {% icon fa-check %} |  |   ▪︎ Local User Authentication   | {% icon fa-check %} | {% icon fa-check %} |
|   ▪︎ Hypervisors                 | {% icon fa-check %} | {% icon fa-check %} |  |   ▪︎ Terminal CLI                | {% icon fa-check %} | {% icon fa-check %} |
|   ▪︎ Cloud providers             | {% icon fa-check %} | {% icon fa-check %} |  |   ▪︎ GUI                         | {% icon fa-check %} | {% icon fa-check %} |
| **Distribution**                |                     |                     |  |   ▪︎ Dashboards                  | {% icon fa-check %} | {% icon fa-check %} |
|   ▪︎ ISO Image                   | {% icon fa-check %} | {% icon fa-check %} |  |   ▪︎ Role Based Management       | {% icon fa-times %} | {% icon fa-check %} |
|   ▪︎ OVA                         | {% icon fa-check %} | {% icon fa-check %} |  |   ▪︎ QoS                         | {% icon fa-times %} | {% icon fa-check %} |
|   ▪︎ Native Container            | {% icon fa-check %} | {% icon fa-check %} |  | **Business Rules**              |                     |                     |
|   ▪︎ AWS AMI                     | {% icon fa-check %} | {% icon fa-check %} |  |   ▪︎ Tagged-Rules Management     | {% icon fa-check %} | {% icon fa-check %} |
|   ▪︎ Azure Marketplace           | {% icon fa-check %} | {% icon fa-check %} |  |   ▪︎ Tag-Based Placement Engine  | {% icon fa-times %} | {% icon fa-check %} |
| **High Availability**           |                     |                     |  |   ▪︎ Tag-Based Policy Engine     | {% icon fa-times %} | {% icon fa-check %} |
|   ▪︎ Persistent Container Storage| {% icon fa-check %} | {% icon fa-check %} |  |   ▪︎ Reporting                   | {% icon fa-times %} | {% icon fa-check %} |
|   ▪︎ Volume HA                   | {% icon fa-times %} | {% icon fa-check %} |  | **Technology Integration**      |                     |                     |
| **Data Security**               |                     |                     |  |   ▪︎ Docker                      | {% icon fa-check %} | {% icon fa-check %} |
|   ▪︎ Volume Encryption           | {% icon fa-times %} | {% icon fa-check %} |  |   ▪︎ rkt                         | {% icon fa-check %} | {% icon fa-check %} |
|                                 |                     |                     |  |   ▪︎ Swarm                       | {% icon fa-times %} | {% icon fa-check %} |
|                                 |                     |                     |  |   ▪︎ Kubernetes                  | {% icon fa-times %} | {% icon fa-check %} |
|                                 |                     |                     |  |                                 |                     |                     | 

StorageOS effectively provides the simplicity and programmability of modern cloud and container-based environments with the functionality of traditional hardware-based storage arrays.



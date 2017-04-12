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

Compared to virtualisation, containers are quick to deploy and tear-down.  Additionally, containers are lightweight allowing more (applications) to be hosted on the same server than would be possible using VMs and at the same time, removing the management overhead of maintaining multiple Operating Systems on a single server.

Being highly portable, containers can be deployed to a variety of public and private cloud infrastructures accelerating test and development cycles and as such, are well suited to Continuous Integration, Continuous Delivery (CI/CD) environments.

![image](/images/docs/started/containers.png)

## How does StorageOS add Value?

StorageOS helps developers move from *host-centric* infrastructure to a more abstracted *container-centric* infrastructure, providing the storage features required to take full advantage of the benefits inherent to containers.

StorageOS satisfies a number of common features for applications running in production, including:

|---------------------------------+---------------------+---------------------+--+---------------------------------+---------------------+---------------------|
| Feature                         |      Developer      |    Professional     |  |Feature                          |      Developer      |    Professional     |
|---------------------------------+---------------------+---------------------+--+---------------------------------+---------------------+---------------------|
| **Data Reduction**              |                     |                     |  | **Data Protection**             |                     |                     |
|   ▪︎ Compression                 | Yes                 | Yes                 |  |   ▪︎ Erasure Coding              | Yes                 | Yes                 |
|   ▪︎ De-duplication              | Yes                 | Yes                 |  |   ▪︎ Advanced Erasure Coding     | No                  | Yes                 |
| **Data Run-Time Management**    |                     |                     |  |   ▪︎ In-Cluster Replicas         | No                  | Yes                 |
|   ▪︎ Resizing, Thin Provisioning | Yes                 | Yes                 |  | **Acceleration**                |                     |                     |
|   ▪︎ Snapshots                   | No                  | Yes                 |  |   ▪︎ SSD Optimized               | Yes                 | Yes                 |
|   ▪︎ Cloning                     | No                  | Yes                 |  |   ▪︎ Run alongside container     | Yes                 | Yes                 |
| **Front-end Connectivity**      |                     |                     |  |   ▪︎ Auto-configuration          | Yes                 | Yes                 |
|   ▪︎ Native connectivity         | Yes                 | Yes                 |  |   ▪︎ Caching                     | No                  | Yes                 |
|   ▪︎ iSCSI                       | Yes                 | Yes                 |  |   ▪︎ Scale-Out                   | No                  | Yes                 |
| **Supported Platforms**         |                     |                     |  | **Management**                  |                     |                     |
|   ▪︎ Linux containers            | Yes                 | Yes                 |  |   ▪︎ Restful API                 | Yes                 | Yes                 |
|   ▪︎ Bare metal                  | Yes                 | Yes                 |  |   ▪︎ Local User Authentication   | Yes                 | Yes                 |
|   ▪︎ Hypervisors                 | Yes                 | Yes                 |  |   ▪︎ Terminal CLI                | Yes                 | Yes                 |
|   ▪︎ Cloud providers             | Yes                 | Yes                 |  |   ▪︎ GUI                         | Yes                 | Yes                 |
| **Distribution**                |                     |                     |  |   ▪︎ Dashboards                  | Yes                 | Yes                 |
|   ▪︎ ISO Image                   | Yes                 | Yes                 |  |   ▪︎ Role Based Management       | No                  | Yes                 |
|   ▪︎ OVA                         | Yes                 | Yes                 |  |   ▪︎ QoS                         | No                  | Yes                 |
|   ▪︎ Native Container            | Yes                 | Yes                 |  | **Business Rules**              |                     |                     |
|   ▪︎ AWS AMI                     | Yes                 | Yes                 |  |   ▪︎ Tagged-Rules Management     | Yes                 | Yes                 |
|   ▪︎ Azure Marketplace           | Yes                 | Yes                 |  |   ▪︎ Tag-Based Placement Engine  | No                  | Yes                 |
| **High Availability**           |                     |                     |  |   ▪︎ Tag-Based Policy Engine     | No                  | Yes                 |
|   ▪︎ Persistent Container Storage| Yes                 | Yes                 |  |   ▪︎ Reporting                   | No                  | Yes                 |
|   ▪︎ Volume HA                   | No                  | Yes                 |  | **Technology Integration**      |                     |                     |
| **Data Security**               |                     |                     |  |   ▪︎ Docker                      | Yes                 | Yes                 |
|   ▪︎ Volume Encryption           | No                  | Yes                 |  |   ▪︎ rkt                         | Yes                 | Yes                 |
|                                 |                     |                     |  |   ▪︎ Swarm                       | No                  | Yes                 |
|                                 |                     |                     |  |   ▪︎ Kubernetes                  | No                  | Yes                 |
|---------------------------------|---------------------|---------------------|--|---------------------------------|---------------------|---------------------|

StorageOS effectively provides the simplicity and programmability of modern cloud and container-based environments with the functionality of traditional hardware-based storage arrays.

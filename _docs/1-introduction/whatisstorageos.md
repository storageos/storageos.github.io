---
layout: guide
title: What is StorageOS?
anchor: introduction
module: 1-introduction/whatisstorageos
---

# What is StorageOS?

StorageOS is an enterprise class Software Defined Storage (SDS) solution optimised for, but not limited to, container-based workloads.  StorageOS works by leveraging the available storage in servers, virtual machines and cloud instances, aggregating and presenting this back as scalable, fully featured software defined enterprise storage.  In doing so, StorageOS ensures data is made portable, persistent, and stored securely and efficiently.

Importantly, StorageOS provides access to persistent data from within containers.  It does this independently of where the application container is running or is re-scheduled.  Regardless of what actions are taken on the application container, the storage will always be there!

StorageOS has been built using modern tools and design methodologies to meet the demands of modern infrastructure and workflows allowing application owners to seamlessly provision and manage their data around rapid development cycles.

StorageOS can be deployed to bare-metal, virtual machines, cloud, or Docker-based infrastructure.  It is designed from the ground up for automation.  Management is simple using an easy to use API, CLI and Web-based UI.  It is available as a free developer tier and pay-as-you-go for beyond 1TB capacities and for enterprise features.

![image](/images/docs/started/storageosinfra.png)

## Why use containers?
Containerisation or Microservices are arguably the next big wave of disruption in technology infrastructure since VMware and virtualisation.

A container comprises an entire runtime environment for an application with all its dependencies in a single package.  By containerising applications, a hosting platform and its dependencies will not run the risk of interfering with application dependencies.

Compared to virtualisation, containers are quick to deploy and tear-down.  Additionally, containers are lightweight allowing more (applications) to be hosted on the same server than would be possible using VMs and at the same time, removing the management overhead of maintaining multiple Operating Systems (OSs) on a single server.

Being highly portable, containers can be deployed to a variety of public and private cloud infrastructures accelerating test and development cycles and as such, are well suited to Continuous Integration, Continuous Delivery (CI-CD) environments.

![image](/images/docs/started/containers.png)

## How does StorageOS add value?

StorageOS helps developers move from *host-centric* infrastructure to a more abstracted *container-centric* infrastructure, providing the storage features required to take full advantage of the benefits inherent to containers.

StorageOS satisfies a number of common features for applications running in production, including:

| Feature                         |   Developer  | Professional |  |Feature                          |   Developer  | Professional |
|:--------------------------------|:------------:|:------------:|:-|:--------------------------------|:------------:|:------------:|
| **Data Reduction**              |              |              |  | **Data Protection**             |              |              |
|   ▪︎ Compression                 |   &#x2714;   |   &#x2714;   |  |   ▪︎ Erasure Coding              |   &#x2714;   |   &#x2714;   |
|   ▪︎ De-duplication              |   &#x2714;   |   &#x2714;   |  |   ▪︎ Advanced Erasure Coding     |   &#x2716;   |   &#x2714;   |
| **Data Run-Time Management**    |              |              |  |   ▪︎ In-Cluster Replicas         |   &#x2716;   |   &#x2714;   |
|   ▪︎ Resizing, Thin Provisioning |   &#x2714;   |   &#x2714;   |  | **Acceleration**                |              |              |
|   ▪︎ Snapshots                   |   &#x2716;   |   &#x2714;   |  |   ▪︎ SSD Optimized               |   &#x2714;   |   &#x2714;   |
|   ▪︎ Cloning                     |   &#x2716;   |   &#x2714;   |  |   ▪︎ Run alongside container     |   &#x2714;   |   &#x2714;   |
| **Front-end Connectivity**      |              |              |  |   ▪︎ Auto-configuration          |   &#x2714;   |   &#x2714;   |
|   ▪︎ Native connectivity         |   &#x2714;   |   &#x2714;   |  |   ▪︎ Caching                     |   &#x2716;   |   &#x2714;   |
|   ▪︎ iSCSI                       |   &#x2714;   |   &#x2714;   |  |   ▪︎ Scale-Out                   |   &#x2716;   |   &#x2714;   |
| **Supported Platforms**         |              |              |  | **Management**                  |              |              |
|   ▪︎ Linux containers            |   &#x2714;   |   &#x2714;   |  |   ▪︎ Restful API                 |   &#x2714;   |   &#x2714;   |
|   ▪︎ Bare metal                  |   &#x2714;   |   &#x2714;   |  |   ▪︎ Local User Authentication   |   &#x2714;   |   &#x2714;   |
|   ▪︎ Hypervisors                 |   &#x2714;   |   &#x2714;   |  |   ▪︎ Terminal CLI                |   &#x2714;   |   &#x2714;   |
|   ▪︎ Cloud providers             |   &#x2714;   |   &#x2714;   |  |   ▪︎ GUI                         |   &#x2714;   |   &#x2714;   |
| **Distribution**                |              |              |  |   ▪︎ Dashboards                  |   &#x2714;   |   &#x2714;   |
|   ▪︎ ISO Image                   |   &#x2714;   |   &#x2714;   |  |   ▪︎ Role Based Management       |   &#x2716;   |   &#x2714;   |
|   ▪︎ OVA                         |   &#x2714;   |   &#x2714;   |  |   ▪︎ QoS                         |   &#x2716;   |   &#x2714;   |
|   ▪︎ Native Container            |   &#x2714;   |   &#x2714;   |  | **Business Rules**              |              |              |
|   ▪︎ AWS AMI                     |   &#x2714;   |   &#x2714;   |  |   ▪︎ Tagged-Rules Management     |   &#x2714;   |   &#x2714;   |
|   ▪︎ Azure Marketplace           |   &#x2714;   |   &#x2714;   |  |   ▪︎ Tag-Based Placement Engine  |   &#x2716;   |   &#x2714;   |
| **High Availability**           |              |              |  |   ▪︎ Tag-Based Policy Engine     |   &#x2716;   |   &#x2714;   |
|   ▪︎ Persistent Container Storage|   &#x2714;   |   &#x2714;   |  |   ▪︎ Reporting                   |   &#x2716;   |   &#x2714;   |
|   ▪︎ Volume HA                   |   &#x2716;   |   &#x2714;   |  | **Technology Integration**      |              |              |
| **Data Security**               |              |              |  |   ▪︎ Docker                      |   &#x2714;   |   &#x2714;   |
|   ▪︎ Volume Encryption           |   &#x2716;   |   &#x2714;   |  |   ▪︎ rkt                         |   &#x2714;   |   &#x2714;   |
|                                 |              |              |  |   ▪︎ Swarm                       |   &#x2716;   |   &#x2714;   |
|                                 |              |              |  |   ▪︎ Kubernetes                  |   &#x2716;   |   &#x2714;   |
|                                 |              |              |  |                                 |              |              | 

StorageOS effectively provides the simplicity and programmability of modern cloud and container-based environments with the functionality of traditional hardware-based storage arrays.



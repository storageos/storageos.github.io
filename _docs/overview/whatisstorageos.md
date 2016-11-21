---
layout: guide
title: What is StorageOS?
anchor: overview
module: overview/whatisstorageos
---

# II. What is StorageOS?

StorageOS is an enterprise class Software Defined Storage (SDS) solution optimised for, but not limited to, container-based workloads.  StorageOS works by leveraging the available storage in servers, virtual machines and cloud instances, aggregating and presenting this back as scalable, fully featured software defined enterprise storage.  In doing so, StorageOS ensures data is made portable, persistent, and stored securely and efficiently.

Importantly, StorageOS provides access to persistent data from within containers.  It does this independently of where the application container is running or is re-scheduled.  Regardless of what actions are taken on the application container, the storage will always be there!

StorageOS has been built using modern tools and design methodologies to meet the demands of modern infrastructure and workflows allowing application owners to seamlessly provision and manage their data around rapid development cycles.

StorageOS can be deployed to bare-metal, virtual machines, cloud, or Docker-based infrastructure.  It is designed from the ground up for automation.  Management is simple using an easy to use API, CLI and Web-based UI.  It is available as a free developer tier and pay-as-you-go for beyond 1TB capacities and for enterprise features.

## A. Why use containers?
Containerisation or Microservices are arguably the next big wave of disruption in technology infrastructure since VMware and virtualisation.

A container comprises an entire runtime environment for an application with all its dependencies in a single package.  By containerising applications, a hosting platform and its dependencies will not run the risk of interfering with application dependencies.

Compared to virtualisation, containers are quick to deploy and teardown.  Additionally, containers are lightweight allowing more (applications) to be hosted on the same server than would be possible using VMs and at the same time, removing the management overhead of maintaining multiple Operating Systems (OSs) on a single server.

Being highly portable, containers can be deployed to a variety of public and private cloud infrastructures accelerating test and development cycles and as such, are well suited to Continuous Integration, Continuous Delivery (CI-CD) environments.



## B. How does StorageOS add value?

StorageOS helps developers move from **host-centric** infrastructure to a more abstracted **container-centric** infrastructure, providing the storage features required to take full advantage of the benefits inherent to containers.

StorageOS satisfies a number of common needs of applications running in production, including:

- Replication
- High Availability
- Performance
- Thin provisioning
- De-duplication
- Compression
- Encryption
- Business rules
- Resource labelling
- Resource monitoring
- Identity and authorisation

This provides the simplicity and programmability of modern cloud and container-based environments with the functionality of traditional hardware-based storage arrays.


<!---
- [replication](/docs/user-guide/pods/) (guarantees data one or more nodes for resilience)
- [high availability](/docs/user-guide/volumes/)
- [performance](/docs/user-guide/secrets/)
- [thin-provisioning](/docs/user-guide/production-pods/#liveness-and-readiness-probes-aka-health-checks)
- [de-duplication](/docs/user-guide/replication-controller/)
- [compression](/docs/user-guide/horizontal-pod-autoscaling/)
- [encryption](/docs/user-guide/connecting-applications/)
- [business rules](/docs/user-guide/services/)
- [resource labelling](/docs/user-guide/update-demo/)
- [resource monitoring](/docs/user-guide/monitoring/)
- [identity and authorization](/docs/admin/authorization/)

This provides the simplicity and programmability of modern cloud and container-based environments with the functionality of traditional hardware-based storage arrays.

For more details, see the [user guide](/docs/user-guide/).
--->

---
layout: guide
title: What is StorageOS?
anchor: overview
module: overview/whatisstorageos
---

# What is StorageOS?

StorageOS is software-only product that turns commodity servers, virtual machines or cloud instances into a storage platform with full enterprise functionality.  It is optimized for container-based workloads.

With StorageOS, you are able to quickly and efficiently manage data:

 - Access persistent data from within containers, independently of where the container is running or gets re-scheduled.
 - Apply business rules for replication and data placement.
 - Optimize spending by adding capacity only as you need it.

StorageOS is a single, lightweight Docker container that can be deployed anywhere.

## StorageOS is:

* **anywhere**: bare-metal, virtual machine, cloud, or docker-based deployment.
* **on-demand**: free developer tier, pay-as-you-go past 1TB of provisioned storage.
* **made-easy**: designed for automation, with easy to use API, CLI and Web UI.

## Why do I need StorageOS and what can it do?

At a minimum, StorageOS aggregates storage capacity available to one or more servers and shares it out to clients.  In doing so, it ensures that the data is made portable, persistent, and stored securely and efficiently.

StorageOS helps developers move from **host-centric** infrastructure to a **container-centric** infrastructure, providing the storage features required to take full advantage of the benefits inherent to containers.

StorageOS satisfies a number of common needs of applications running in production, such as:

* [replication](/docs/user-guide/pods/), ensures that data is copied to one or more nodes for resilience,
* [high availability](/docs/user-guide/volumes/),
* [performance](/docs/user-guide/secrets/),
* [thin-provisioning](/docs/user-guide/production-pods/#liveness-and-readiness-probes-aka-health-checks),
* [de-duplication](/docs/user-guide/replication-controller/),
* [compression](/docs/user-guide/horizontal-pod-autoscaling/),
* [encryption](/docs/user-guide/connecting-applications/),
* [business rules](/docs/user-guide/services/),
* [resource labelling](/docs/user-guide/update-demo/),
* [resource monitoring](/docs/user-guide/monitoring/),
* [identity and authorization](/docs/admin/authorization/).

This provides the simplicity and programmability of modern cloud and container-based environments with the functionality of traditional hardware-based storage arrays.

For more details, see the [user guide](/docs/user-guide/).

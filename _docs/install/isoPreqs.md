---
layout: guide
title: Installation Prerequisites
anchor: install
module: install/isoPrereqs
---

# Installation Prerequisites

## Overview
Our first product is a software-only platform that you to create your own fully functional storage array using containers, servers, virtual machines, cloud instances, or any combination of these platforms.  StorageOS is packaged into a single small footprint container that you can download from the web for free. This allows you to use commodity hardware, local disk, or cloud-based storage to create enterprise-class storage platforms, and manage your data at a per GB per month operating expenditure (opex).  

Key solution sets include storage for databases, hybrid cloud, cloud migration, low entry point enterprise storage, and very low cost warm standby disaster recovery.

## Deployment options
This deployment option uses an Ubuntu-based installable image, installable anywhere that you can use a CD, including VirtualBox, VMware, HyperV, and bare metal. It likely does not work on most cloud systems. We are working on derivative images to be available for AWS, Azure, and GCE. For installation on a laptop or developer workstation, we recommend using VirtualBox.

This documentation assumes that you are installing StorageOS on VirtualBox (5.0.16+). We have also tested the application on VMware Workstation using similar settings. Contact StorageOS for help with VMware Workstation installations.
### Hypervisor settings
If you are installing StorageOS in a Hypervisor environment, use the following settings.
**Note**: We have successfully tested these settings. If you use other things that work, please let us know.
### ESX hosts
* USB or disk space on a data store to mount the ISO install image
* ESX 5.5 or higher
* HA Enabled
* Odd number of StorageOS server nodes in the cluster (e.g., we recommended one-, three-, or five-node clusters)
* Storage presented to all nodes of the ESX cluster for HA and VMotion to work per VMware’s requirements (SAN, VSAN, iSCSI, etc.) SSD obviously performs best, but any storage should work
* Anti-affinity configured to prevent StorageOS controllers from running on the same ESX host

The following TCP ports must be open between the StorageOS controllers, Docker clients, and management node:
* 80
* 4222
* 8000
* 17100

### TCP port
TCP port 8222 must be open between StorageOS appliances only.

### VMs for the StorageOS appliance
Use different ESX hosts if you are installing more than one  one????<--what is this?
* Ubuntu 64-bit guest OS setting
* Two vCPUs
* 4GB RAM
* 100GB+ data volume for the root filesystems and data pool presented by local or shared storage (will be able to present multiple volumes from different disk types in GA)
* one vnic in same vlan as the Docker environment (10GbE preferred - DV switch supported)
* One IP address for each server (static DHCP preferred)
* Direct Internet access to download containers (proxy support will be added in future release)

## Docker nodes
Use the following specifications for the StorageOS Client if separate from the  StorageOS Server (one on each node accessing StorageOS persistent volumes)
* Docker 1.10 or 1.11, but not 1.12.0
* Ubuntu 14.04 or higher with systemd preferred, but any V3 or V4 Linux kernel should work
* Root access for client install
* Ability to restart Docker on each node for install (restart containers on that node)
* Containers for testing
* StorageOS Configuration
 * Pools configured for each type of storage on each node (e.g. VSAN, SolidFire)
 * Single user for management (beta only)

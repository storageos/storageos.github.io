---
layout: guide
title: Installation Requirements
anchor: overview
module: overview/deployment
---

# IV. Installation Requirements

There are a number of requirements that need to be met based on your environment and testing scope.

## A. Before you Start
Before you start, please read this section before moving to the Installation Guide section as it may save you time in the end!

StorageOS is a Linux only installation, however depending on your testing scope, StroageOS can be installed onto macOS, Windows and Linux environments test environments using VirtualBox.

Recommendations on the practical maximum cluster members have yet to be published.  We are however interested in hearing from you on what works (and what doesn’t) in your environment.  The design does not for example impose constraints such as maximum, or odd number of nodes.

## B. Beta Release
For this Beta release we have two installation options (1) an Ubuntu Linux ISO image and (2) a Vagrant Ubuntu Linux image.  Either method can be used with your choice of Operating System (OS).

- If you are planning to explore StorageOS on Linux server infrastructure in VMs or on bare metal, the ISO image installation will be your preferred choice.

- If you are planning to explore StorageOS on a desktop or notebook, Vagrant will give you the added convenience of managing the StorageOS machine image acquisition and setup for you.

>**&#x270F; Note**: For secure, firewalled enterprise environments, acquiring the necessary Vagrant images may fail depending on your security policies – in this case consider the ISO install.
>
>**&#x270F; Note**: For the ISO-based deployment, Consul is bundled to store configuration data. Consul requires an odd number of nodes, we therefore stipulate ISO-based clusters have 3, 5, or 7 nodes.

## C. <a name="VirtualBox"></a> VirtualBox
For either installation method, you’ll need to install VirtualBox for the OS you’ll be hosting this from.  At the time of writing, VirtualBox is available for Windows, Linux, macOS, and Solaris hosts.  If you don’t already have this installed, VirtualBox is freely available as Open Source software and can be obtained from [**VirtualBox**](https://www.virtualbox.org) under the terms of the GNU General Public License V2.

All the necessary documentation required to get you up and running with VirtualBox is available from their website.
If you are planning to use the ISO install method, you can proceed to the next section.

## D. <a name="Vagrant"></a> Vagrant
At the time of writing, Vagrant is available for macOS, Windows, Debian Linux and CentOS Linux environments.  Once you have Vagrant installed on your system, getting StorageOS up and running couldn’t be any simpler.

Vagrant is freely available as Open Source software and can be obtained from [**Vagrant**](http://vagrantup.com) under the terms of the MIT License.

All the necessary documentation required to get you up and running with Vagrant is available from the website.


<!--- ## Number of Controllers

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

**Note**: This is a Beta version of the software. Do NOT, under any circumstances, use this version for production. You should assume that any data stored on this storage array is non-essential test data and may be lost at any time. We are testing a zero downtime, data-in-place upgrade processes now, and this feature will be ready for GA. Until this is ready, assume upgrades may require that you redeploy the product restore data. --->

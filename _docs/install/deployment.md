---
layout: guide
title: Installation Requirements
anchor: install
module: install/deployment
---

# Installation Requirements

## Before you Start
Please read this section before moving to the Installation Guide section. It may save you time!

StorageOS runs on Linux. StorageOS runs well in VMs and can be installed onto macOS, Windows and Linux environments using VirtualBox or VMware.

We are still determining our recommended specifications for virtual or physical hardware, and for the suggested
numbers of nodes for common use cases. We are interested in hearing about users' experience of what does and doesn't works
in their environments.

The design of StorageOS does not impose arbitrary constraints on the number of nodes. Note, however,
that the ISO install will install Consul, which _does_ mandate an odd number of nodes for server installations.

## Beta Release
For this Beta release we have two installation options, an Ubuntu-derived Linux ISO image, and a Vagrant box for VirtualBox and VMware desktop.  Either method can be used with your choice of host OS.

- If you are planning to run StorageOS on infrastructure VMs or on bare metal, the ISO image installation is a good choice.

- If you are planning to run StorageOS on a desktop or notebook, Vagrant will manage the StorageOS machine image acquisition and setup for you.

>**&#x270F; Note**: Your site security policies may prohibit the download of the Vagrant box from a workstation. In this case consider the ISO install. You will need some way to download and use either the box or the ISO image.

>**&#x270F; Note**: For the ISO-based deployment, configuration data are stored in a node-local Consul installation that the ISO installer provides. For correct operation, Consul requires an odd number of nodes. For a practical deployment we specify that clusters installed using the ISO image have 3, 5, or 7 nodes. Other combinations are possible but will require additional work.

## System Requirements

StorageOS Beta can be installed onto x86_64 server, desktop or laptop environments.  For a virtual machine-based deployment, at least one x86_64-capable hypervisor system is required.

### Hardware Requirements

1. Below are minimum and recommended requirements for a VM installlation.

   | Component       | Minimum         | Recommended     |
   |:--------------- |----------------:| ---------------:|
   | CPU             |  2 Virtual CPUs |  Dedicated Cores|
   | Memory per VM   |    1,536GB      |        4,096GB  |
   | Disk Storage    |    50GB         |          100GB+ |
   | Virtual NIC     |               - |               - |

Any reasonable baremetal system will exceed the VM requirements by a large margin. We have no specific requirements above the VM specification, but clearly
faster hardware, particularly with fast disks (ideally SSDs) and fast NICs will give better performance.

>**&#x270F; Note**: The disk storage is thinly provisioned, so volumes can be specified that exceed the amount of actual storage.  However, if you plan to
    work with creating volumes and generating data we have recommended you have at least 50GB available for setting up your enviroment.

>**&#x270F; Note**: For the ISO build, ideally a static DHCP address should be assigned to each node otherwise accept the DHCP address that appears during
    the Ubuntu setup process.  The MAC address can be obtained under the Advanced section of the Network properties for each VM under VirtualBox, or
    from inside the VM's OS using `ip addr`.

### Network Requirements

The following TCP ports need to be open between the StorageOS controllers, Docker clients, and management node


   | Service           | Port Number        |
   |:------------------|-------------------:|
   | UI                |        80/tcp      |
   | NATS              |      4222/tcp      |
   | UI and API        |      8000/tcp      |
   | NATS              |      8222/tcp      |
   | Consul            | 8500/tcp, 8500/udp |
   | Serf              |      13700/udp     |
   | DirectFS server   |      17100/tcp     |


## Deployment Options

There are currently two options for installing StorageOS

- **Vagrant**: This is the simplest choice to get you up and running quickly. Vagrant boxes for VirtualBox and VMware Fusion/Workstation are provided.
- **ISO image**: This is a custom Linux distribution based on Ubuntu 16.04 LTS. We recommend the VirtualBox hypervisor for the Beta as this has been more extensively tested and requires no additional third party licensing.

### <a name="Vagrant"></a> Vagrant
Vagrant is available for macOS, Windows, Debian Linux and CentOS Linux environments. It is Open Source and can be obtained from the Hashicorp [Vagrant web site](http://vagrantup.com) under the terms of the MIT License.

All the necessary documentation required to get you up and running with Vagrant is available from the site.

### ISO image

The ISO image is a customised Ubuntu Server 16.04 LTS distribution that preinstalls and configures a base StorageOS installation.

It is installable anywhere an Ubuntu Server 16.04 LTS can be installed. It has received the most testing on VirtualBox and VMware desktop VMs,
and on baremetal installations.

Please Contact StorageOS for help with VMware Workstation installations if you are have problems with the installation.

## Hypervisor Options

Our software is built and tested using VirtualBox, and that is currently the best-tested deployment. VMware desktop and ESX have also been tested.

### <a name="VirtualBox"></a> VirtualBox
VirtualBox is available for Windows, Linux, macOS, and Solaris hosts. It is Open Source and can be obtained from the Oracle [VirtualBox web site](http://virtualbox.org), under the terms of the GNU General Public License V2.

All the necessary documentation required to get you up and running with VirtualBox is available from the site.

### VMware ESX
The StorageOS ISO image can of course be installed onto VMware ESX machines, and you can request additional support directly from StorageOS for assistance with this process. We do not support the VMware plug-in for the Beta Vagrant build at this time.

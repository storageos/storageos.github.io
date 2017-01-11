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

We are still determining our recommended specifications for virtual or physical hardware, and for the suggested numbers of nodes for common use cases. We are interested in hearing about users' experiences of what does and does not work in their environments.

The design of StorageOS does not impose arbitrary constraints on the number of nodes. Note, however, that the ISO install will install Consul, which mandates an odd number of nodes for server installations.


## Beta Release
For this Beta release we have two installation options, (1) an Ubuntu-derived Linux ISO image, and (2) a Vagrant box for VirtualBox and VMware desktop.  Either method can be used with your choice of host OS.

1. If you are planning to run StorageOS on infrastructure VMs or on bare metal, the ISO image installation is a good choice.

2. If you are planning to run StorageOS on a desktop or notebook, Vagrant will manage the StorageOS machine image acquisition and setup for you and will not get confused if your IP subnet changes.

>**Note**: Your site security policies may prohibit the download of the Vagrant box from a workstation. In this case consider the ISO install. You will need some way to download and use either the box or the ISO image.

>**Note**: For the ISO-based deployment, configuration data is stored in a node-local Consul installation that the ISO installer provides. For correct operation, Consul requires an odd number of nodes. For a practical deployment we specify that clusters installed using the ISO image have 3, 5, or 7 nodes. Other combinations are possible but will require additional work and physical resources.

>**Note**: If for any reason you run into a problem during the ISO installation process and need to rebuild a node, please ensure that the bad node is completely removed from VirtualBox and built from scratch using a new VM 'container'.  To make this easier you can create a default template and clone your VMs from this.


## System Requirements

StorageOS Beta can be installed onto x86_64 server, desktop or laptop environments.  For a virtual machine-based deployment, at least one x86_64-capable hypervisor system is required.

### Hardware Requirements

1. Below are minimum and recommended requirements for a VM installation.

    | Component       | Minimum         | Recommended     |
    |:--------------- |----------------:| ---------------:|
    | CPU             |  2 Virtual CPUs |  Dedicated Cores|
    | Memory per VM   |    1,536GB      |        4,096GB  |
    | Disk Storage    |    50GB         |          100GB+ |
    | Virtual NIC     |               - |               - |

Most usable bare metal systems should comfortably meet the VM requirements. We have no specific requirements beyond what is tabled above, however, faster hardware, particularly fast disks (ideally SSDs) and fast NICs will provide improved performance.

>**Note**: The disk storage is thinly provisioned, so volumes can be specified that exceed the amount of actual storage.  However, if you plan to work with creating volumes and generating data we have recommended you have at least 50GB available for setting up your environment.

>**Note**: For the ISO build, ideally a static DHCP address should be assigned to each node otherwise accept the DHCP address that appears during the Ubuntu setup process.  The MAC address can be obtained under the Advanced section of the Network properties for each VM under VirtualBox, or from inside the VM's OS using `ip addr`.

### Network Requirements

1. The following TCP ports need to be open between the StorageOS controllers, Docker clients, and management node


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

1. **Vagrant**: This is the simplest choice to get you up and running quickly. Vagrant boxes for VirtualBox and VMware Fusion/Workstation are provided.
2. **ISO image**: This is a custom Linux distribution based on Ubuntu 16.04 LTS. We recommend the VirtualBox hypervisor for the Beta as this has been more extensively tested and requires no additional third party licensing.

### Vagrant
Vagrant is available for macOS, Windows, Debian Linux and CentOS Linux environments and is Open Source software.  The software and documentation can be obtained from the [Hashicorp Vagrant](http://vagrantup.com) web site.

### ISO image

The ISO image is a customised Ubuntu Server 16.04 LTS distribution that preinstalls and configures a base StorageOS installation.

It is installable anywhere that an Ubuntu Server 16.04 LTS can be installed. It has received the most testing on VirtualBox and VMware desktop VMs, and on bare metal installations.

Please Contact StorageOS for help with VMware Workstation installations if you are have problems with the installation.


## Hypervisor Options

Our software is built and tested using VirtualBox, and that is currently the best-tested deployment. VMware desktop and ESX have also been tested.

### VirtualBox
VirtualBox is available for Windows, Linux, macOS, and Solaris hosts and is Open Source software.  The software and documentation can can be obtained from the [Oracle VirtualBox web site](http://virtualbox.org).  

### VMware ESX
The StorageOS ISO image can also be installed onto VMware ESX machines.  You can request additional support directly from StorageOS should you require further assistance with this process. We do not support the VMware plug-in for the Beta Vagrant build at this time however.

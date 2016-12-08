---
layout: guide
title: Installation Requirements
anchor: install
module: install/deployment
---

# Installation Requirements

There are a number of requirements that need to be met based on your environment and testing expectations.

## Before you Start
Before you start, please read this section before moving to the Installation Guide section as it may save you time in the end!

StorageOS is a Linux only installation, however depending on your testing scope, StroageOS can be installed onto macOS, Windows and Linux environments test environments using VirtualBox.

Recommendations on the practical maximum cluster members have yet to be published.  We are however interested in hearing from you on what works (and what doesn’t) in your environment.  The design does not for example impose constraints such as maximum, or odd number of nodes.

## Beta Release
For this Beta release we have two installation options (1) an Ubuntu Linux ISO image and (2) a Vagrant Ubuntu Linux image.  Either method can be used with your choice of host Operating System (OS).

- If you are planning to explore StorageOS on Linux server infrastructure in VMs or on bare metal, the ISO image installation will be your preferred choice.

- If you are planning to explore StorageOS on a desktop or notebook, Vagrant will give you the added convenience of managing the StorageOS machine image acquisition and setup for you.

    >**&#x270F; Note**: For secure, firewalled enterprise environments, acquiring the necessary Vagrant images may fail depending on your security policies – in this case consider the ISO install.
    >
    >**&#x270F; Note**: For the ISO-based deployment, Consul is bundled to store configuration data. Consul requires an odd number of nodes, we therefore stipulate ISO-based clusters have 3, 5, or 7 nodes.

## System Requirements

StorageOS Beta can be installed onto x86 server, desktop or laptop environemnts.  As you will be running this in a virtual envoronment however, only one piece of x86 hardware is required.

### Hardware Requirements

1. Below are a set of minimum and recommended requirements for your installlaion.

   | Component       | Minimum         | Recommended     |
   |:--------------- |----------------:| ---------------:|
   | CPU             |  2 Virtual CPUs |  Dedicated Cores|
   | Memory per VM   |    1,536GB      |        4,096GB  |
   | Disk Storage    |    50GB         |          100GB+ |
   | NIC             |  Virtual NIC    |   Virtual NIC   |
   |

    >**&#x270F; Note**: The disk storage is thinly provisioned and will require anything up top around 16GB initially, perhaps less.  However if you plan to work with creating volumes and generating data we have recommended you have at least 50GB available for setting up your enviroment.
    >
    >**&#x270F; Note**: For the ISO build, ideally a static DHCP address should be assigned to each node otherwise accept the DHCP address that appears during the Ubuntu setup process.  The MAC address can be obtained under the Advanced section of the Network properties for each VM under VirtualBox.

### Network Requirements

1. The following TCP ports need to be open between the StorageOS controllers, Docker clients, and management node

   TCP port 8222 only needs to be opened between StorageOS nodes.

   | Service     | Flow           | Port Number     |
   |:------------|:---------------|----------------:|
   | A           |inbound/outbound|      80         |
   | B           |inbound/outbound|      4222       |
   | C           |inbound/outbound|      8000       |
   | StorageOS   |inbound/outbound|      8222       |
   | D           |inbound/outbound|      17100      |
   |

## Deployment Options

There are essentially two options for installing StorageOS

1. Vagrant, this is by fat the simplist choice to get you up and running quickly wich is dependant on VirtualBoxand
2. ISO, this is an automated Ubuntu install which requires bare-metal or a hypervisor.  We would recommend the VirtualBox hyoervisor  for the Beta as this has been more extensively tested and requires no additional third party licensing.

### <a name="Vagrant"></a> Vagrant
At the time of writing, Vagrant is available for macOS, Windows, Debian Linux and CentOS Linux environments.  Once you have Vagrant installed on your system, getting StorageOS up and running couldn’t be simpler.

Vagrant is freely available as Open Source software and can be obtained from the Hashicorp Vagrant website under the terms of the MIT License.  Click on the image below to download.

[<img src="/images/docs/install/vagrant.png" width="300">](http://vagrantup.com)

All the necessary documentation required to get you up and running with Vagrant is available from the website.

### ISO

This deployment option uses an Ubuntu-based installable image, installable anywhere that you can use a CD, including VirtualBox, VMware, HyperV, and bare metal. We have not however tested this in any cloud environments including AWS, Azure, and GCE. For installation on a laptop or developer workstation, we recommend using VirtualBox.

This documentation assumes that you are installing StorageOS on VirtualBox. We have also tested the application on VMware Workstation using similar settings. Contact StorageOS for help with VMware Workstation installations if you are unable to get the installation process started.

## Hypervisor Options

For either installation , ISO or Vagrant, we recomend installing VirtualBox for the OS you’ll be hosting this from.

### <a name="VirtualBox"></a> VirtualBox
At the time of writing, VirtualBox is available for Windows, Linux, macOS, and Solaris hosts.  If you don’t already have this installed, VirtualBox is freely available as Open Source software and can be obtained from the Oracle VirtualBox web site under the terms of the GNU General Public License V2.  Click on the image below to download.

[<img src="/images/docs/install/virtualbox.png" width="300">](http://virtualbox.org)

All the necessary documentation required to get you up and running with VirtualBox is available from their website.
If you are planning to use the ISO install method, you can proceed to the next section.

### ESX
Should your environment dictate that StorageOS is installed onto ESX instead of VirtualBox, you can request additional support directly from StorageOS if you run into any complications.  This option is only open to the ISO installation, we do not support the VMware plug-in for the Beta Vagrant build at this time.

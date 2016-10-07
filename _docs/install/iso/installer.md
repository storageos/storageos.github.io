---
layout: guide
title: Installing StorageOS
anchor: install
module: install/iso/installer
---

# Installing StorageOS

Installing StorageOS involves starting the VM, installing the Linux operating system, and setting up the StorageOS cluster. Configure as many VMs for the StorageOS ISO installation as you want to test, but it must be an odd number. You can create an ESX template to simplify the installation process.

## Installing Linux
Follow these steps on each VM to install Linux. These instructions direct you to select the options that work best with the beta version of StorageOS, and assume that you followed the instructions in <insert link to Creating the VMs using VirtualBox>.

1.  Start the VM:

 ![image](/images/docs/isoinstall/ISOinstall1.png)

2. The VM boots into the StorageOS installer. Select your language as prompted and press __Enter__.

 ![image](/images/docs/isoinstall/ISOinstall2.png)

3. Select the first option, __Install StorageOS on Ubuntu Server__ by pressing __Enter__ to continue.

4. Select the server installation language and press __Enter__ to continue.

5. Select your time zone and press __Enter__ to continue.

6. Select __Yes__ to choose to automatically detect your keyboard layout and press __Enter__ to continue. Answer the prompts presented and confirm your keyboard by choosing __Continue__ and pressing __Enter__. Or, indicate the country of origin for the keyboard of your computer and press __Enter__, then indicate the layout matching your machine's keyboard and press __Enter__ to continue.

7. The installation process loads additional components and detects the network via DHCP. Enter a hostname for your system and press __Enter__ to continue:

 ![image](/images/docs/isoinstall/ISOinstall3.png)

8. Create a __user account__, __user name__, and __password__ (and verify that password), pressing __Enter__ to continue each time:  

 ![image](/images/docs/isoinstall/ISOinstall4.png)

 ![image](/images/docs/isoinstall/ISOinstall5.png)

 ![image](/images/docs/isoinstall/ISOinstall6.png)

9. Select __No__ for home directory encryption and press __Enter__ to continue.

10. Confirm (__Yes__) or change (__No__) your time zone as appropriate and press __Enter__ to continue.

11. Select the disk and partition type for the installation disk.
 - For a newly partitioned volume, select __Guided - use entire disk and set up LVM__:

 ![image](/images/docs/isoinstall/ISOinstall7.png)

 - If you are upgrading or reinstalling StorageOS (assuming you created a boot disk as disk1), select __Guided - use entire partition, partition #1 (sda)__ (the default):

 ![image](/images/docs/isoinstall/ISOinstall8.png)

 - Verify that you chose the correct disk, partition, and volume, then select the sda and press __Enter__.

  ![image](/images/docs/isoinstall/ISOinstall9.png)

12. Choose __Yes__ to verify that you will write over the entire disk and then verify the size. Select __Continue__, and verify that you want to write the disk again (Choose __Yes__).

13. The installation continues, and you are prompted to enter an HTTP proxy for internet access. Enter the proxy information as appropriate (or leave it blank if you do not have one), and press __Enter__ to continue. The installer continues to install the software.

14. Choose __No automatic updates__ (default) by pressing __Enter__.

 ![image](/images/docs/isoinstall/ISOinstall10.png)

15. Do not select additional software when prompted. Press __Enter__ to accept the defaults and continue.

16. Choose __Yes__ to install the GRUB boot loader and press __Enter__. The Linux install completes.

## Configuring the StorageOS cluster

This section describes how to configure a StorageOS cluster. We use three a three-node cluster.

1.  Specify __Yes__ that you are creating a new StorageOS cluster when installing the first node in the cluster:

 ![image](/images/docs/isoinstall/cluster1.png)

2. Choose the number of nodes in your new StorageOS cluster:

 ![image](/images/docs/isoinstall/cluster2.png)

3. Confirm or modify the IP address of the new cluster and press __Enter__. Make sure you note this IP address because for the subsequent nodes in the cluster, you will need to specify this IP address when configuring each node.

 ![image](/images/docs/isoinstall/cluster3.png)

4. The installation completes and you are prompted to reboot.

 ![image](/images/docs/isoinstall/cluster4.png)

5. Press __Enter__ to reboot the VM. The login screen for that new virtual machine appears:

 ![image](/images/docs/isoinstall/cluster5.png)

You now have the latest version of the StorageOS software installed.

## Verifying the Installation

To verify that your installation:

1. Open a browser and enter the IP address of your VM. You connect to StorageOS, as shown below:

 ![image](/images/docs/isoinstall/VerifyInstall.png)

2. Enter the username __storageos__ and password __storageos__. The StorageOS Dashboard is displayed:

  ![image](/images/docs/isoinstall/VerifyInstall2.png)

3. Click __Configuration__, then __Controllers__. You can see the three installed StorageOS controllers and their capacity, with one of the three nodes as a scheduler (the Scheduler column is __true__ for that node) :

  ![image](/images/docs/isoinstall/VerifyInstall3.png)

 You have completed the installation process.

  ---

---
layout: guide
title: Downloading the ISO image
anchor: install
module: install/download
---

# Downloading the ISO image
Download the StorageOS ISO image from the USB stick we provided or from the following location:

https://downloads.storageos.com/images/storageos-ubuntu-16.04-amd64.iso

You must specify the following username and password to download the image.

 - Username: __download__

 - Password: __roh6kei7Oig2__

:warning: Do not give out the username/password to anyone who has not signed an NDA.
# Creating the Virtual Machines using Virtual Box
 1. Launch Oracle VM VirtualBox.

 2. Select __New__, and:

  * Enter a __name__ for your VM (for example **Storageos**)
  * For Type, select __Linux__
  * For Version, select __Ubuntu (64-bit)__
  * Click __Next__.

 ![image](/images/docs/isoinstall/VBCreate1.png)

__Note__: If you do not have the 64-bit options from the Version drop-down menu, you most likely need to enable __Virtualization Technology__ in the Windows bios settings.

 3. Set the memory size to __2GB__ and click __Next__.

 4. Keep the default (__Crate a virtual hard disk now__) and click __Create__.

 5. For the storage type, choose __VDI__ (the default) and click __Next__.

 6. Set the storage on physical hard disc to __Dynamically allocated__ and click __Next__.

  ![image](/images/docs/isoinstall/VBCreate2.png)

 7. Set the file location and leave the default size and click __Create__.

8. To prepare for the StorageOS installation, select the newly create VM and click __Settings__.

  ![image](/images/docs/isoinstall/VBCreate3.png)

  * Select __Storage__
  * Click the empty CD,
  * Click the CD icon in the upper right configuring-containers
  * Navigate and choose the StorageOS Ubuntu ISO file you downloaded earlier, then click __OK__.

  ![image](/images/docs/isoinstall/ISOselect.png)

  * Select __Network__ then choose __Bridged Adapter__ from the *Attached to* drop-down, then click __OK__.

   ![image](/images/docs/isoinstall/ISOselect2.png)

 ```conf
NAT will not work with iSCSI. It may be possible to setup NAT on another interface
 but port forwarding to the other services will also need to be setup. This is
 currently undocumented & untested.
 ```

---
layout: guide
title: Confirming Installation
anchor: install
module: install/confirm
---

# V. Confirming Installation

StorageOS Control plane API is accessible either through port 80 or 8000.

## A. Verifying the Installation

To verify that your installation:

1. Open a browser and enter the IP address of your VM. You connect to StorageOS, as shown below:

    <img src="/images/docs/iso/weblogin.png" width="640">


2. Enter the username __storageos__ and password __storageos__. The StorageOS Dashboard is displayed:

    <img src="/images/docs/iso/webui.png" width="640">

3. Click __Configuration__, then __Controllers__. You can see the three installed StorageOS controllers and their capacity, with one of the three nodes as a scheduler (the Scheduler column is __true__ for that node) :

  ![image](/images/docs/isoinstall/VerifyInstall3.png)

 You have completed the installation process.

  ---


---

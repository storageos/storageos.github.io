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

1. Open a browser and enter the IP address of one of the StorageOS nodes.  For the ISO image build enter the StorageOS user name and password you configured during the installation phase.  For Vagrant this will be user name of vagrant and password of vagrant.

    <img src="/images/docs/iso/weblogin.png" width="640">

2. Click **Configuration**, then **Controllers**. You will see the StorageOS nodes you built and their capacity, with one of the three nodes as a scheduler (the Scheduler column is **true** for that node).  Providing everything installed and configured correctly, the **System Status** in the left hand column should be set to **OK** and green.

    <img src="/images/docs/iso/webui.png" width="640">


 You have completed the installation process.

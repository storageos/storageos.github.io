---
layout: guide
title: Confirming Installation
anchor: install
module: install/startwebui
---

# Confirming Installation

A simple litmus test to confirm that the installation has completed successfully is to launch the Web UI from your browser.

For the ISO build this will be any of the three IP addresses you configured that show up on each node's MOTD banner.

For Vagrant, you will need to connect to one of the following IP addresses accessible over the VirtualBox NAT interface:

1. [10.245.103.2](http://10.245.103.2)
2. [10.245.103.3](http://10.245.103.3)
3. [10.245.103.4](http://10.245.103.4)


## Verifying the Installation

To verify that your installation:

1. Open a browser and enter the IP address of one of the StorageOS nodes.  For both the ISO build enter the StorageOS user name and password you configured during the installation phase.  For the Vagrant build this will be storageos, storageos.

    ![screenshot](/images/docs/iso/weblogin.png)

2. Click **Configuration**, then **Controllers**. You will see the StorageOS nodes you built and their capacity, with one of the three nodes as a scheduler (the Scheduler column is **true** for that node).  Providing everything installed and configured correctly, the **System Status** in the left hand column should be set to **OK** and green.

    <a name="WebUI"></a>[<img src="/images/docs/iso/webui.png" width="760">](./webuipng.html)

 You have completed the installation process.

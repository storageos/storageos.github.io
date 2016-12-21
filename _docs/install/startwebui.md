---
layout: guide
title: Confirming Installation
anchor: install
module: install/startwebui
---

# <a name="top"></a> Confirming Installation

You can check that the installation has completed successfully by launching the Web UI.

If you have configured DNS for your nodes, you can browse to them by name. Otherwise, you'll need to browse to a node's IP address.

For the ISO build, this will be any of the nodes' IP addreses as found in your VM configuration or on the node's console.

For Vagrant, you will need to connect to *any* of the nodes' IP addresses. Unless you've made site-local changes to
the `Vagrantfile`, the addresses will be:

```
10.205.103.2
10.205.103.3
10.205.103.4
```

## Verifying the Installation

To verify that your installation:

1. Open a browser and browse to the name (if registered in DNS) or IP address of one of the StorageOS nodes, at http://ip-or-name/.  For both the ISO build enter the StorageOS user name and password you configured during the installation phase.  For the Vagrant build this will be storageos, storageos.

   >**&#x270F; Note**: If you just started up the cluster it takes about a minute or so for the services to come on line before the StorageOS login screen appears in your browser window.

    ![screenshot](/images/docs/iso/weblogin.png)

1. Click **Configuration**, then **Controllers**. You will see the StorageOS nodes you built and their capacity, with one of the three nodes as a scheduler (the Scheduler column is **true** for that node).  Providing everything installed and configured correctly, the **System Status** in the left hand column should be set to **OK** and green.

    <a name="WebUI"></a>[<img src="/images/docs/iso/webui.png" width="760">](./webuipng.html)

 You have completed the installation process.

<div style="text-align: right"> <a href="#top"> Back to top </a> </div>

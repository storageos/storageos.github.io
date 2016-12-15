---
layout: guide
title: ISO Installation
anchor: install
module: install/iso
---

# ISO Installation

There are three parts to completing the ISO image install of StorageOS:

1. Creating VMs with VirtualBox or ESX for each StorageOS cluster node
1. Installing StorageOS and Ubuntu Server from ISO media for each VirtualBox cluster node in your cluster
1. Confirming the setup has completed successfully - this also covers the Vagrant install and is covered in the next section

You should already have the ISO downloaded from the previous section [Downloading the StorageOS media](../install/media.html#Downloading) and should be ready to setup your VirtualBox environment.

## Creating VMs with VirtualBox

Before you can begin the ISO image install, you will need to create a **minimum of 3** StorageOS cluster nodes by repeating the steps below.  You can create as many as you like providing you choose an odd number of nodes.

### Create Initial VM

1. Launch VirtualBox
1. Select **New**

   <img src="/images/docs/iso/vbnew.png">

1. Select ![Expert Mode](/images/docs/iso/vbexpert.png)
1. Enter a **name** for your VM (for example **StorageOS-01** for the first node)
1. For Type, select **Linux**
1. For Version, select **Ubuntu (64-bit)**
1. Type in **4096** for the memory allocation
1. Select the **Create a virtual hard disk now** radio button
1. Click ![Create](/images/docs/iso/vbcreate.png) to proceed to the next step of configuring the virtual disk
1. A resulting dialogue box will appear

    ![screenshot](/images/docs/iso/vbcreate1.png)


   >**&#x270F; Note**: If the 64-bit options from the Version drop-down menu are unavailable you you may need to enable Virtualization Extensions for your system.
   >
   >**&#x270F; Note**: If you do not have sufficient memory in your test environment you can select less, for example 1536MB; 4096MB however is the optimal size.

### Configure Virtual Disk

1. Set the File size to **16 GB**, this is the minimum size necessary if you wish to create StorageOS volumes later.
1. Under **Hard disk file type** select the **VDI (VirtualBox Disk Image)** radio box
1. Under **Storage on physical hard drive** select **Dynamically allocated**
1. Click ![Create](/images/docs/iso/vbcreate.png) to create you VM image

    ![screenshot](/images/docs/iso/vbcreate2.png)

### Configure Disk Settings

1. With your newly created VM selected, click from the **Settings** button on the VirtualBox main menu to configure **Storage**

    ![image](/images/docs/iso/vbsettings.png)

1. From the resulting dialogue box, select **Storage**
1. Under **Storage Tree**, select **&#x1F4BF; Empty**
1. Under **Attributes** select the &#x1F4BF; icon next to **IDE Secondary Master** and then **Choose Virtual Optical Disk File...**
1. Browse to the location where you saved the StorageOS ISO image earlier and select it
1. Finish by clicking ![image](/images/docs/iso/ok.png)

    <img src="/images/docs/iso/vbiso.png" width="870">

### Configure Network Settings

1. Click on the **Settings** button again from the VirtualBox main menu to configure **Network**

    ![image](/images/docs/iso/vbsettings.png)

1. From the resulting dialogue box, select **Network**
1. Select **Adapter 1**
1. Next to the **Attached to:** label use the drop-down list to select **Bridged Adapter**
1. Confirm that an adapter is present next to the **Name:** label

   >**&#x270F; Note**: NAT will not work with iSCSI. It may be possible to setup NAT on another interface but port forwarding to the other services will also need to be setup. This is currently undocumented & untested.
   >
   >**&#x270F; Note**: If you are configuring Static DHCP addresses for each of your nodes, these can be located under the advanced properties of the Network configuration dialogue you have open above.

1. Finish by clicking ![image](/images/docs/iso/ok.png)

    ![screenshot](/images/docs/iso/macaddress.png)

## VMware ESX Virtual Machine Creation

Should you wish to test StorageOS using ESX instead of VirtualBox, you can create a virtual machine with the following settings ESX settings:

* USB or disk space on a data store to mount the ISO install image
* ESX 5.5 or higher
* HA Enabled
* As stated previously, an odd number of nodes in the cluster
* Storage presented to all nodes of the ESX cluster for HA and VMotion to work based on VMware’s requirements (SAN, VSAN, iSCSI, etc.)
* Anti-affinity configured to prevent StorageOS controllers from running on the same ESX host

1. Ensure you add a smaller disk for a boot partition it will be used for the StorageOS ISO image installation:

    ![screenshot](/images/docs/iso/esxbootpart.png)

1. You may wish to configure Hard disk 1 as thin provisioned in ESX to conserve space. This volume can be any size you want (10GB is required for StorageOS volumes plus 40MB for StorageOS container).

   >**&#x270F; Note**: You may configure 3, 5 or 7 nodes from the StorageOS ISO install as desired. More nodes are possible with manual configuration,
   but there must always be an odd number of nodes or Consul will not operate correctly.
   >
   >**&#x270F; Note**: You can also create an ESX template to simplify the install if you wish.


## Installing StorageOS and Ubuntu Server from ISO Media

You are now ready to boot each of your VMs and install StorageOS.

### Starting up your VMS
Follow the steps below for each VM to install StorageOS with Ubuntu Server. The first VM will be the designated as the master node,
so ensure this VM completes first before completing the remaining member nodes.

Note that the master node is not 'special'; it is simply a convenience during installation. Once the install is complete and the
Consul cluster is started, all server nodes are equivalent.

These instructions direct you to select the options that work best with the beta release of StorageOS.

1. Begin by starting up VirtualBox and selecting the first VM you created in the previous section.

    ![screenshot](/images/docs/iso/vms.png)

1.  Select your preferred language

    ![image](/images/docs/iso/1-isolang.png)

1. Select **Install StorageOS on Ubuntu Server**

    ![image](/images/docs/iso/2-isostorageos.png)

### Setting the Language and Keyboard

1. For the next set of menu selections you will be presented with, you will need to use your keyboard to select and navigate the appropriate options.

    To do this use the **Tab** key to move across the options, use the **Space Bar** to select an option and use the **Enter** key to accept an option.

    ![screenshot](/images/docs/iso/0-isomenu.png)

1. Select your preferred language

    ![screenshot](/images/docs/iso/3-isolang.png)

1. Select your location

    ![screenshot](/images/docs/iso/4-isotime.png)

1. Select **No** to manually setup your keyboard

    ![screenshot](/images/docs/iso/5-isokybd.png)

1. Select the country that matches your keyboard

    ![screenshot](/images/docs/iso/6-isokybd.png)

1. Select the country layout that matches your keyboard

    ![screenshot](/images/docs/iso/7-isokybd.png)

### Configuring Host Settings

1. Enter a hostame for the system - for example you can use the format **storageos-<##>** for each of your VMs as they increment

    ![screenshot](/images/docs/iso/9-isonet.png)

1. Setup the user name you will use to login and administer each of your you nodes - the same name for all nodes is recommended.

   ![screenshot](/images/docs/iso/10-isousers.png)

1. Enter a name - for example, the same name as what you just entered earlier.

   ![screenshot](/images/docs/iso/11-isousers.png)

1. Enter the password - again, the same password for all nodes is recommended.

    ![screenshot](/images/docs/iso/12-isousers.png)

1. Re-enter the password

    ![screenshot](/images/docs/iso/13-isousers.png)

1. Select **No** to not encrypt your home directory

    ![screenshot](/images/docs/iso/14-isousers.png)

1. Select **Yes** to accept the suggested time zone or if this is incorrect follow the options to set this correctly

    ![screenshot](/images/docs/iso/15-isoclock.png)

### Disk Partition Setup

1. For the disk partition setup, select the default option, **Guided - use entire disk and set up LVM**

    ![screenshot](/images/docs/iso/16-isopart.png)

1. Select the default disk device to partition

    ![screenshot](/images/docs/iso/17-isopart.png)

1. Accept **Yes** to write the changes and configure the Logical Volume Manager

    ![screenshot](/images/docs/iso/18-isopart.png)

1. Accept the default, maximum available size for your partition - this should be in the region of 16GB

    ![screenshot](/images/docs/iso/19-isopart.png)

1. Select **Yes** to accept the changes to be writtin to disk

    ![screenshot](/images/docs/iso/20-isopart.png)

### Configuring Updates and Packages

1. If you use a proxy server to access the internet, please enter it now, otherwise leave this blank and continue

    ![screenshot](/images/docs/iso/21-isopack.png)

1. We will not be using automatic updates for this Beta build so please select the default "No automatic updates"

    ![screenshot](/images/docs/iso/22-isoupd.png)

1. The only package we require for StorageOS is the **OpenSSH Server** - please select this option and continue

    ![screenshot](/images/docs/iso/23-isosw.png)

### GRUB and StorageOS Cluster Setup

1. Select **Yes** to install the GRUB boot loader to the MBR. (Though unlikely, this may appear differently or not
at all on some systems, depending on the hardware.)

    ![screenshot](/images/docs/iso/24-isogrub.png)

1. If this is the first node of your cluster, select **Yes**

    ![screenshot](/images/docs/iso/25-isocluster.png)

1. If ths is not the first node of your cluster, select **No**

    ![screenshot](/images/docs/iso/26-isocluster.png)

1. Select the number of nodes you wish to setup in the cluster

   >**&#x270F; Note**: The number of nodes available are odd - this is a restriction of consul

    ![screenshot](/images/docs/iso/27-isocluster.png)

1. If this is the first node in the cluster accept the automatically assigned DHCP address and **note down the IP address** as the subsequent nodes in the cluster will need this when you set them up next

    ![screenshot](/images/docs/iso/28-isocluster.png)

    If however this is a member node, you will be asked to manually enter the IP address of the StorageOS cluster leader

    ![screenshot](/images/docs/iso/28a-isoleaderip.png)

    >**&#x270F; Note**: This needs to be an address you have assigned as a Static DHCP or one that has been automatically assigned for you by DHCP.  If a DHCP address appears in the IP address field, this is the address you need to accept before you can continue.

1. If this is a member node, after entering the StorageOS cluster leader IP address you will subsequently  be asked to confirm the assigned IP address for the new node

    ![screenshot](/images/docs/iso/28-isocluster1.png)

    >**&#x270F; Note**: As noted above.

### Completing your Installation

1. At this point the installation should be complete - select **Continue** to restart the VM

    ![screenshot](/images/docs/iso/29-isocomplete.png)

    ![screenshot](/images/docs/iso/30-isosigterm.png)


1. On startup you will be presented with an MOTD on the console for each VM - note the IP address displayed for each console.  You will need this to access the Web GUI from any of the give VMs cluster nodes you have completed.

    ![screenshot](/images/docs/iso/31-isoconsole.png) <!--- reduce image size to 640 pixels --->

### Confirm SSH has been installed and Docker containers are running

1.  To connect to an ISO install StorageOS node, simply ssh from the terminal.  When you connect for the first time you will be asked to accept the ECDSA key from the remote host.  Type `yes` to accept.

    ```bash
    StorageOS:storageos julian$ ssh -l storageos storageos-03
    The authenticity of host '10.1.5.173 (10.1.5.173)' can't be established.
    ECDSA key fingerprint is SHA256:tCd0ShYOm8xM14travkzSizv75UsIPOdXOD8YIg84S8.
    Are you sure you want to continue connecting (yes/no)? yes
    Warning: Permanently added '10.1.5.173' (ECDSA) to the list of known hosts.
    storageos@10.1.5.173's password:
    Welcome to Ubuntu 16.04 LTS (GNU/Linux 4.4.0-21-generic x86_64)

      * Documentation:  https://help.ubuntu.com/

    The programs included with the Ubuntu system are free software;
    the exact distribution terms for each program are described in the
    individual files in /usr/share/doc/*/copyright.

    Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
    applicable law.

    To run a command as administrator (user "root"), use "sudo <command>".
    See "man sudo_root" for details.
    ```

### Confirm Docker containers are running

1.  Running the `docker ps` command will display what is currently running on the node.

    ```bash
    storageos@storageos-01:~$ docker ps -a
    CONTAINER ID  IMAGE                              COMMAND                  CREATED        STATUS                  PORTS                                                                                                           NAMES
    4dff1fa7eec2  consul:latest                      "docker-entrypoint.sh"   4 minutes ago  Up 3 minutes                                                                                                                            consul
    3419a5cd1947  quay.io/storageos/storageos:beta   "/bin/storageos boots"   12 days ago    Exited (0) 12 days ago                                                                                                                  storageos_cli_run_1
    1ae8a05b15db  quay.io/storageos/storageos:beta   "/bin/storageos contr"   12 days ago    Up 3 minutes            0.0.0.0:4222->4222/tcp, 0.0.0.0:8000->8000/tcp, 0.0.0.0:8222->8222/tcp, 0.0.0.0:80->8000/tcp                    storageos_control_1
    3dd074c85fbd  quay.io/storageos/influxdb:beta    "influxd --config /et"   12 days ago    Up 3 minutes            2003/tcp, 4242/tcp, 8083/tcp, 8088/tcp, 25826/tcp, 8086/udp, 0.0.0.0:8086->8086/tcp, 0.0.0.0:25826->25826/udp   storageos_influxdb_1
    87e86b1b434e  quay.io/storageos/storageos:beta   "/bin/storageos datap"   12 days ago    Up 4 minutes                                                                                                                            storageos_data_1
    ```

1.  You can also use the `storageos` command to gather the status of the dataplane, controlplane and the Web UI metrics collection containers

    ```bash
    root@storageos-03:~# storageos status
            Name                      Command               State                                                       Ports
    -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    storageos_control_1    /bin/storageos controlplane      Up      0.0.0.0:4222->4222/tcp, 0.0.0.0:80->8000/tcp, 0.0.0.0:8222->8222/tcp
    storageos_data_1       /bin/storageos dataplane         Up
    storageos_influxdb_1   influxd --config /etc/infl ...   Up      2003/tcp, 25826/tcp, 0.0.0.0:25826->25826/udp, 4242/tcp, 8083/tcp, 0.0.0.0:8086->8086/tcp, 8086/udp, 8088/tcp
    root@storageos-03:~#
    ```

1.  To disconnect your session simply type `Ctrl + D` to return back to your original shell prompt:

    ```bash
    storageos@storageos-01:~$ logout
    Connection to 10.1.5.171 closed.
    storageos:~ julian$
    ```

You should now have successfully completed the StorageOS cluster setup.

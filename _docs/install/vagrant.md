---
layout: guide
title: Vagrant Installation
anchor: install
module: install/vagrant
---

# Vagrant Installation

As well as having the Vagrant software installed, you will also need to have VirtualBox or VMware Fusion/Workstation installed.  See the [deployment](deployment.html) section for more details.

## Setting up the Vagrant Environment

Copy the `Vagrantfile` downloaded from [https://storageos.com/download](https://storageos.com/download) into a new base directory.  We'll use `~/storageos` throughout the documentation.

You run Vagrant from a command line. This is any shell window for Linux or macOS, and a Command Prompt or Powershell (recommended) for Windows.

### Viewing and Modifying the Vagrantfile

Before you launch Vagrant for the first time to build out your cluster, you may want to change some of the default settings. You can do this by either (1) directly editing the `Vagrantfile` in your base directory or by (2) setting environmnt variables.

1. To configure the cluster size, CPU or amount of allocated memory, locate the relevant lines towards the top of the Vagrantfile:
   * To run a single-node cluster, change the value `3` for `STORAGEOS_NODES` to `1`
   * To manage down CPU resources, change the value `2` for `STORAGEOS_CPU` to `1`
   * To manage down memory resources, change the value `2048` for `STORAGEOS_MEMORY` to `1536` or `1024`

2. Alternatively you can set the necessary enviroment variables for the OS you are running:

   ![icon](/images/docs/iso/macterm.png) For macOS and Linux, set your environment from the terminal window you will run Vagrant commands from:
    
   ```bash
   STORAGEOS_NODES=1
   STORAGEOS_CPU=1
   STORAGEOS_MEMORY=1536
   ```

   --or--

   ```bash
   export STORAGEOS_NODES=1 STORAGEOS_CPU=1 STORAGEOS_MEMORY=1536
   ```

   ![icon](/images/docs/iso/winterm.png) For Windows, set your environment from the command window you will run Vagrant commands from:
    
   ```doscon
   set STORAGEOS_NODES=1
   set STORAGEOS_CPU=1
   set STORAGEOS_MEMORY=1536
   ```
--or-- (PowerShell)

   ```powershell
   $env:STORAGEOS_NODES=1
   $env:STORAGEOS_CPU=1
   $env:STORAGEOS_MEMORY=1536
   ```


## Initialise the Cluster

1. From the base `storageos` folder initialise the StorageOS Vagrant cluster:

   ```bash]
   $ vagrant up
   Bringing machine 'storageos-01' up with 'virtualbox' provider...
   Bringing machine 'storageos-02' up with 'virtualbox' provider...
   Bringing machine 'storageos-03' up with 'virtualbox' provider...
   ...
   ```

   >**Note**: If you want to use the VMware provider instead of VirtualBox you will need to specify the VMware provider for Vagrant to use the first time you bring up your cluster:
   >
   > ![icon](/images/docs/iso/appleicon.png) `vagrant up --provider=vmware_fusion`
   >
   > ![icon](/images/docs/iso/windowsicon.png) `vagrant up --provider=vmware_workstation`

   >**Note**: You'll need to have the VMware Fusion or VMware Workstation vagrant plug-in installed and licensed first - see the [HashiCorp Vagrant VMware](https://www.vagrantup.com/vmware/) documentation for details

2. After a couple of minutes the installation will complete - check the Vagrant cluster node status using the `vagrant status` command:

   ```bash
   $ vagrant status
   Current machine states:

   storageos-01               running (virtualbox)
   storageos-02               running (virtualbox)
   storageos-03               running (virtualbox)

   This environment represents multiple VMs. The VMs are all listed
   above with their current state. For more information about a specific
   VM, run `vagrant status NAME`.
   ```

## Confirming the Installation

### Confirm VDI Disks have been Created (VirtualBox)

1. For VirtualBox, based on the `Vagrantfile` parameters you will see one or more VDI volumes allocated to each node:

   ```bash
   $ ls *.vdi
   storageos-01-disk0.vdi	storageos-02-disk0.vdi	storageos-03-disk0.vdi
   ```

### Confirm SSH has been Installed and Docker Containers are Running

1. To remote shell into the cluster you should use the `vagrant ssh` command and specify the node you wish to connect in the case of a multi-node cluster setup:

   ```bash
   $ vagrant ssh storageos-01
   Welcome to Ubuntu 16.04.1 LTS (GNU/Linux 4.4.0-21-generic x86_64)

   * Documentation:  https://help.ubuntu.com
   * Management:     https://landscape.canonical.com
   * Support:        https://ubuntu.com/advantage
   Last login: Tue Dec 13 12:27:42 2016 from 10.0.2.2
   ```

2. Running the `docker ps` command will display what is currently running on the node:

   ```bash
   $ docker ps -a
   CONTAINER ID  IMAGE                              COMMAND                  CREATED        STATUS                  PORTS                                                                                                           NAMES
   4dff1fa7eec2  consul:latest                      "docker-entrypoint.sh"   4 minutes ago  Up 3 minutes                                                                                                                            consul
   3419a5cd1947  quay.io/storageos/storageos:beta   "/bin/storageos boots"   12 days ago    Exited (0) 12 days ago                                                                                                                  storageos_cli_run_1
   1ae8a05b15db  quay.io/storageos/storageos:beta   "/bin/storageos contr"   12 days ago    Up 3 minutes            0.0.0.0:4222->4222/tcp, 0.0.0.0:8000->8000/tcp, 0.0.0.0:8222->8222/tcp, 0.0.0.0:80->8000/tcp                    storageos_control_1
   3dd074c85fbd  quay.io/storageos/influxdb:beta    "influxd --config /et"   12 days ago    Up 3 minutes            2003/tcp, 4242/tcp, 8083/tcp, 8088/tcp, 25826/tcp, 8086/udp, 0.0.0.0:8086->8086/tcp, 0.0.0.0:25826->25826/udp   storageos_influxdb_1
   87e86b1b434e  quay.io/storageos/storageos:beta   "/bin/storageos datap"   12 days ago    Up 4 minutes                                                                                                                            storageos_data_1
   ```

3. You can also use the `storageos` command to gather the status of the *dataplane*, *controlplane* and the Web UI metrics collection containers

   ```bash
   $ storageos status
   Name                      Command               State                                                            Ports
   ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   storageos_control_1    /bin/storageos controlplane      Up      0.0.0.0:13700->13700/tcp, 0.0.0.0:13700->13700/udp, 0.0.0.0:4222->4222/tcp, 0.0.0.0:80->8000/tcp, 0.0.0.0:8222->8222/tcp
   storageos_data_1       /bin/storageos dataplane         Up
   storageos_influxdb_1   influxd --config /etc/infl ...   Up      2003/tcp, 25826/tcp, 0.0.0.0:25826->25826/udp, 4242/tcp, 8083/tcp, 0.0.0.0:8086->8086/tcp, 8086/udp, 8088/tcp
   ```

4. To disconnect your session, hit `CTRL+D` to return back to your original shell prompt:

   ```bash
   $ logout
   Connection to 127.0.0.1 closed.
   ```

5. To shut down your Vagrant VM cluster use the `vagrant halt` command.

   ```bash
   $ vagrant halt
   ==> storageos-3: Attempting graceful shutdown of VM...
   ==> storageos-2: Attempting graceful shutdown of VM...
   ==> storageos-1: Attempting graceful shutdown of VM...
   ```

This completes the StorageOS cluster setup.

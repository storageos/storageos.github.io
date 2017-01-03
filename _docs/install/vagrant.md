---
layout: guide
title: Vagrant Installation
anchor: install
module: install/vagrant
---

# Vagrant Installation

You will need the StorageOS Vagrantfile in the base directory created [earlier](deployment.html). We'll use `~/storageos` here.

As well as having the Vagrant software installed, you will also need to have VirtualBox (or VMware Fusion/Workstation) installed.

## Setting up the Vagrant Environment

Before you launch Vagrant for the first time to build out your cluster, you will want to view the `Vagrantfile` file in your base directory.

You run Vagrant from a command line. This is any shell window for UNIX or macOS, and a Command Prompt or Powershell for Windows.
We recommend Powershell.

### Viewing or modifying the Vagrantfile

1.  To configure the cluster size and number of clients, the relevant lines can be found at the top of the file.  So for example:
    * You want to run a single-node cluster by  changing the `3` on the `STORAGEOS_NODES` line to `1`
    * You want to manage down CPU resources by changing the `2` on the `STORAGEOS_CPU` line to `1`
    * You want to manage down memory resources by changing `2048` on the `STORAGEOS_MEMORY` line to `1536`

    These can also be set via environment variables. For UNIX:

    ```
    export STORAGEOS_NODES=1 STORAGEOS_CPU=1 STORAGEOS_MEMORY=1536
    ```

    For Powershell:

    ```
    $env:STORAGEOS_NODES=1
    $env:STORAGEOS_CPU=1
    $env:STORAGEOS_MEMORY=1536
    ```

## Initialise the Cluster

1.  From the base storageos folder initialise the StorageOS Vagrant cluster:

    ```
    StorageOS:storageos julian$ vagrant up
    Bringing machine 'storageos-1' up with 'virtualbox' provider...
    Bringing machine 'storageos-2' up with 'virtualbox' provider...
    Bringing machine 'storageos-3' up with 'virtualbox' provider...
    ...
    ```

    >**&#x270F; Note**: If you want to use the VMware provider instead of VirtualBox you will need to specify the VMware provider for Vagrant to use the first time you bring up your cluster:
    > <br> <img src="/images/docs/iso/appleicon.png" width="25"> `vagrant up --provider=vmware_fusion`
    > <br> <img src="/images/docs/iso/windowsicon.png" width="25"> `vagrant up --provider=vmware_workstation`

    >**&#x270F; Note**: You'll need to have the VMware Fusion or VMware Workstation vagrant plug-in installed and licensed first - see the HashiCorp [<img src="/images/docs/iso/vagranticon1.png" height="18">](https://www.vagrantup.com/vmware/) integration page for details


2.  After a couple of minutes the installation will complete - check the Vagrant cluster node status using the `vagrant status` command:

    ```
    StorageOS:storageos julian$ vagrant status
    Current machine states:

    storageos-1               running (virtualbox)
    storageos-2               running (virtualbox)
    storageos-3               running (virtualbox)

    This environment represents multiple VMs. The VMs are all listed
    above with their current state. For more information about a specific
    VM, run `vagrant status NAME`.
    ```

## Confirming the installation

### Confirm VDI disks have been created (VirtualBox)

1.  For VirtualBox, based on the `Vagrantfile` parameters you will see one or more VDI volumes allocated to each node:

    ```
    StorageOS:storageos julian$ ls *.vdi
    storageos-1-disk0.vdi	storageos-2-disk0.vdi	storageos-3-disk0.vdi
    ```

### Confirm SSH has been installed and Docker containers are running

>**&#x270F; Note**: There are additional steps to set up SSH for Windows. Your Windows machine
> may already have an SSH client installed. We've had good results using
> [Git for Windows](https://git-scm.com/download/win).
> In any case, you need an executable
> SSH program in your `PATH` for `vagrant ssh` to work.

> Set the path in Windows 10
> by right-clicking on the Start icon and selecting 'System', then select 'Advanced system settings'
> then 'Environment variables'. Under 'user variables', edit 'Path', and add the
> path to your SSH.
> For Git for Windows installed with defaults, the path was `C:\Program Files\git\usr\bin`.
> Open a new Powershell or Command Prompt and type `ssh`. If you get an error, the `PATH` isn't
> right or SSH isn't working properly.

1.  To remote shell into the cluster you should use the `vagrant ssh` command and specify the node you wish to connect in the case of a multi-node cluster setup:

    ```
    StorageOS:storageos julian$ vagrant ssh storageos-1
    Welcome to Ubuntu 16.04.1 LTS (GNU/Linux 4.4.0-21-generic x86_64)

    * Documentation:  https://help.ubuntu.com
    * Management:     https://landscape.canonical.com
    * Support:        https://ubuntu.com/advantage
    Last login: Tue Dec 13 12:27:42 2016 from 10.0.2.2
    ```

2.  Running the `docker ps` command will display what is currently running on the node:

    ```
    vagrant@storageos-1:~$ docker ps -a
    storageos@storageos-02:~$ docker ps -a
    CONTAINER ID  IMAGE                              COMMAND                  CREATED        STATUS                  PORTS                                                                                                           NAMES
    4dff1fa7eec2  consul:latest                      "docker-entrypoint.sh"   4 minutes ago  Up 3 minutes                                                                                                                            consul
    3419a5cd1947  quay.io/storageos/storageos:beta   "/bin/storageos boots"   12 days ago    Exited (0) 12 days ago                                                                                                                  storageos_cli_run_1
    1ae8a05b15db  quay.io/storageos/storageos:beta   "/bin/storageos contr"   12 days ago    Up 3 minutes            0.0.0.0:4222->4222/tcp, 0.0.0.0:8000->8000/tcp, 0.0.0.0:8222->8222/tcp, 0.0.0.0:80->8000/tcp                    storageos_control_1
    3dd074c85fbd  quay.io/storageos/influxdb:beta    "influxd --config /et"   12 days ago    Up 3 minutes            2003/tcp, 4242/tcp, 8083/tcp, 8088/tcp, 25826/tcp, 8086/udp, 0.0.0.0:8086->8086/tcp, 0.0.0.0:25826->25826/udp   storageos_influxdb_1
    87e86b1b434e  quay.io/storageos/storageos:beta   "/bin/storageos datap"   12 days ago    Up 4 minutes                                                                                                                            storageos_data_1
    ```

3.  You can also use the `storageos` command to gather the status of the *dataplane*, *controlplane* and the Web UI metrics collection containers

    ```
    root@storageos-03:~# storageos status
    Name                      Command               State                                                            Ports
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    storageos_control_1    /bin/storageos controlplane      Up      0.0.0.0:13700->13700/tcp, 0.0.0.0:13700->13700/udp, 0.0.0.0:4222->4222/tcp, 0.0.0.0:80->8000/tcp, 0.0.0.0:8222->8222/tcp
    storageos_data_1       /bin/storageos dataplane         Up
    storageos_influxdb_1   influxd --config /etc/infl ...   Up      2003/tcp, 25826/tcp, 0.0.0.0:25826->25826/udp, 4242/tcp, 8083/tcp, 0.0.0.0:8086->8086/tcp, 8086/udp, 8088/tcp
    ```

4.  To disconnect your session, hit `CTRL+D` to return back to your original shell prompt:

    ```
    vagrant@storageos-1:~$ logout
    Connection to 127.0.0.1 closed.
    StorageOS:storageos julian$
    ```

5.  To shut down your Vagrant VM cluster use the `vagrant halt` command.

    ```
    storageos:storageos julian$ vagrant halt
    ==> storageos-3: Attempting graceful shutdown of VM...
    ==> storageos-2: Attempting graceful shutdown of VM...
    ==> storageos-1: Attempting graceful shutdown of VM...
    storageos:storageos julian$
    ```

This completes the StorageOS cluster setup.



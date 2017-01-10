---
layout: guide
title: Vagrant Installation
anchor: install
module: 3-install/vagrant
---

# Vagrant Installation

As well as having the Vagrant software installed, you will also need to have VirtualBox or VMware Fusion/Workstation installed.  See the [deployment](deployment.html) section for more details.

## Setting up the Vagrant Environment

Copy the `Vagrantfile` downloaded from [https://storageos.com/download](https://storageos.com/download) into a new base directory.  We'll use `~/storageos` throughout the documentation.

You run Vagrant from a command line. This is any shell window for Linux or macOS, and a Command Prompt or Powershell (recommended) for Windows.

### Viewing or modifying the Vagrantfile

Before you launch Vagrant for the first time to build out your cluster, you may want to change the default settings.  

You may do this by editing the `Vagrantfile` file in your base directory, or by setting environment variables.  The examples below show methods for:
* Running a single-node cluster by setting `STORAGEOS_NODES` to `1` (default `3`)
* Managing down CPU resources by setting `STORAGEOS_CPU` to `1` (default `2`)
* Managing down memory resources by setting `STORAGEOS_MEMORY` to `1536` (default `2048`)

#### Vagrantfile {% icon fa-apple fa-border %} {% icon fa-linux fa-border %} {% icon fa-windows fa-border %}
Edit the `Vagrantfile` using a text editor. The relevant lines can be found at the top of the file.
* Change the `3` on the `STORAGEOS_NODES` line to `1`
* Change the `2` on the `STORAGEOS_CPU` line to `1`
* Change the `2048` on the `STORAGEOS_MEMORY` line to `1536`

#### Environment variables: macOS and Linux {% icon fa-apple fa-border %} {% icon fa-linux fa-border %}

```
export STORAGEOS_NODES=1 STORAGEOS_CPU=1 STORAGEOS_MEMORY=1536
```

#### Environment variables: Windows Powershell {% icon fa-windows fa-border %}

```
$env:STORAGEOS_NODES=1
$env:STORAGEOS_CPU=1
$env:STORAGEOS_MEMORY=1536
```

#### Environment variables: Windows Command Prompt {% icon fa-windows fa-border %}

```
set STORAGEOS_NODES=1
set STORAGEOS_CPU=1
set STORAGEOS_MEMORY=1536
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

    >**Note**: If you want to use the VMware provider instead of VirtualBox you will need to specify the VMware provider for Vagrant to use the first time you bring up your cluster:
    >
    > {% icon fa-apple fa-border %} `vagrant up --provider=vmware_fusion`
    >
    > {% icon fa-windows fa-border %} `vagrant up --provider=vmware_workstation`

    >**Note**: You'll need to have the VMware Fusion or VMware Workstation vagrant plug-in installed and licensed first - see the [HashiCorp Vagrant VMware](https://www.vagrantup.com/vmware/) documentation for details

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

>**Note**: There are additional steps to set up SSH for Windows. Your Windows machine
> may already have an SSH client installed. We've had good results using
> [Git for Windows](https://git-scm.com/download/win).
> In any case, you need an executable
> SSH program in your `PATH` for `vagrant ssh` to work.

> **Note**: Set the path in Windows 10
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

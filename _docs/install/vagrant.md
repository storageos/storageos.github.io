---
layout: guide
title: Vagrant Installation
anchor: install
module: install/vagrant
---

# Vagrant Installation

To begin the Vagrant installation you will need to your base directory as discussed at the end of the previous section.  So for a developer you might want to use ~/storageos.

As well as having Vagrant installed, you will also need to have VirtualBox installed which was covered in the previous sections.

## Setting up the Vagrant Environmnet

Before you launch Vagrant for the first time and build out the cluster, you will want to edit the file names Vagrantfile in the base directory.

### Modifying the Vagrantfile

1.  To configure the cluster size and number of clients, the relevant lines can be found at the top of the file.  So for example, if you want a single-node cluster, change the `3` on the `STORAGEOS_NODES` line to `1`.

2.  It is also recommended you add the line `"pull = false"` as shown below to surpress verbose messages during the initialisation.

    ```ruby
    # Set to 1 for single, or 3 or 5 for HA
    $channel = (ENV['STORAGEOS_CHANNEL'] || "alpha")
    $num_node = (ENV['STORAGEOS_NODES'] || 3).to_i
    $num_client = (ENV['STORAGEOS_CLIENTS'] || 0).to_i
    $num_disk = (ENV['STORAGEOS_DISKS'] || 8).to_i
    $node_ip_base = (ENV['STORAGEOS_IP_BASE'] || "10.245.10") + "#{$num_node}" + "."
    $client_ip_base = (ENV['STORAGEOS_CLIENT_IP_BASE'] || "10.245.20") + "#{$num_client}" + "."
    $node_ips = $num_node.times.collect { |n| $node_ip_base + "#{n+2}" }
    $client_ips = $num_client.times.collect { |n| $client_ip_base + "#{n+2}" }
    $leader_ip = $node_ips[0]

    pull = false
    ```

## Initialise the Cluster

1.  From the base storageos folder initialise the StorageOS Vagrant cluster:

    ```bash
    StorageOS:storageos julian$ vagrant up
    Cloning/pulling updates from StorageOS source repositories...
    Note: set SKIP_PULL=true environment variable to skip updates
    Cloning src/dkr/build branch 'develop': Cloning into 'src/dkr/build'...
    ...
    ```
2.  After a couple of minutes the installation should be complete - check the Vagrant cluster node status using the `vagrant status` command:

    ```bash
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

### Confirm VDI disks have been created

1.  Based on the default Vagrantfile paramaters you will see 8 vdi volumes allocated to each node tarting at 0:

    ```bash
    StorageOS:storageos julian$ ls *.vdi
    storageos-1-disk0.vdi	storageos-2-disk0.vdi	storageos-3-disk0.vdi
    storageos-1-disk1.vdi	storageos-2-disk1.vdi	storageos-3-disk1.vdi
    storageos-1-disk2.vdi	storageos-2-disk2.vdi	storageos-3-disk2.vdi
    storageos-1-disk3.vdi	storageos-2-disk3.vdi	storageos-3-disk3.vdi
    storageos-1-disk4.vdi	storageos-2-disk4.vdi	storageos-3-disk4.vdi
    storageos-1-disk5.vdi	storageos-2-disk5.vdi	storageos-3-disk5.vdi
    storageos-1-disk6.vdi	storageos-2-disk6.vdi	storageos-3-disk6.vdi
    storageos-1-disk7.vdi	storageos-2-disk7.vdi	storageos-3-disk7.vdi
    ```

### Confirm SSH has been installed and Docker containers are running

1.  To remote shell into the cluster you should use the `vagrant ssh` command and sepcify the node you wish to connect in the case of a multi-node cluster setup:

    ```bash
    StorageOS:storageos julian$ vagrant ssh storageos-1
    Welcome to Ubuntu 16.04.1 LTS (GNU/Linux 4.4.0-21-generic x86_64)

     * Documentation:  https://help.ubuntu.com
     * Management:     https://landscape.canonical.com
     * Support:        https://ubuntu.com/advantage
    vagrant@storageos-1:~$
    ```

2.  Running the `docker ps` command will display what is currently running on the node:

    ```bash
    vagrant@storageos-1:~$ docker ps -a
    storageos@storageos-02:~$ docker ps -a
    CONTAINER ID  IMAGE                              COMMAND                  CREATED        STATUS                  PORTS                                                                                                           NAMES
    4dff1fa7eec2  consul:latest                      "docker-entrypoint.sh"   4 minutes ago  Up 3 minutes                                                                                                                            consul
    3419a5cd1947  quay.io/storageos/storageos:beta   "/bin/storageos boots"   12 days ago    Exited (0) 12 days ago                                                                                                                  storageos_cli_run_1
    1ae8a05b15db  quay.io/storageos/storageos:beta   "/bin/storageos contr"   12 days ago    Up 3 minutes            0.0.0.0:4222->4222/tcp, 0.0.0.0:8000->8000/tcp, 0.0.0.0:8222->8222/tcp, 0.0.0.0:80->8000/tcp                    storageos_control_1
    3dd074c85fbd  quay.io/storageos/influxdb:beta    "influxd --config /et"   12 days ago    Up 3 minutes            2003/tcp, 4242/tcp, 8083/tcp, 8088/tcp, 25826/tcp, 8086/udp, 0.0.0.0:8086->8086/tcp, 0.0.0.0:25826->25826/udp   storageos_influxdb_1
    87e86b1b434e  quay.io/storageos/storageos:beta   "/bin/storageos datap"   12 days ago    Up 4 minutes                                                                                                                            storageos_data_1
    ```

3.  You can also use the `storageos` command to gather the status of the dataplane, controlplane and the Web UI metrics collection containers

    ```bash
    root@storageos-03:~# storageos status
            Name                      Command               State                                                       Ports
    -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    storageos_control_1    /bin/storageos controlplane      Up      0.0.0.0:4222->4222/tcp, 0.0.0.0:80->8000/tcp, 0.0.0.0:8222->8222/tcp
    storageos_data_1       /bin/storageos dataplane         Up
    storageos_influxdb_1   influxd --config /etc/infl ...   Up      2003/tcp, 25826/tcp, 0.0.0.0:25826->25826/udp, 4242/tcp, 8083/tcp, 0.0.0.0:8086->8086/tcp, 8086/udp, 8088/tcp
    root@storageos-03:~#
    ```

4.  To disconnect your session simply type `Ctrl + D` to return back to your original shell prompt:

    ```bash
    vagrant@storageos-1:~$ logout
    Connection to 127.0.0.1 closed.
    StorageOS:storageos julian$
    ```

5.  To shutdown your Vagrant VM cluster use the `vagrant halt` command.

    ```bash
    storageos:storageos julian$ vagrant halt
    ==> storageos-3: Attempting graceful shutdown of VM...
    ==> storageos-2: Attempting graceful shutdown of VM...
    ==> storageos-1: Attempting graceful shutdown of VM...
    storageos:storageos julian$
    ```


You should now have successfully completed the StorageOS cluster setup.

---
layout: guide
title: Vagrant Installation
anchor: install
module: install/vagrant
---

# Vagrant Installation

To begin the Vagrant installation you will need to your base directory as discussed at the end of the previous section.  So for a developer you might want to use ~/storageos.

## Setting up the Vagrant Environmnet

Before you launch Vagrant for the first time and build out the cluster, you will want to edit the file names Vagrantfile in the base directory.  To configure the cluster size and number of clients, the relevant lines can be found at the top of the file.  So for example, if you want a single-node cluster, change the `3` on the `STORAGEOS_NODES` line to `1`.

It is also recommended you add the line `"pull = false"` as shown below to surpress verbose messages during the initialisation.

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

From the base storageos folder initialise the StorageOS Vagrant cluster:

```text
StorageOS:storageos julian$ vagrant up
Cloning/pulling updates from StorageOS source repositories...
Note: set SKIP_PULL=true environment variable to skip updates
Cloning src/dkr/build branch 'develop': Cloning into 'src/dkr/build'...
...
```
After a couple of minutes the installation should be complete - check the Vagrant cluster node status using the `vagrant status` command:

```text
StorageOS:storageos julian$ vagrant status
Current machine states:

storageos-1               running (virtualbox)
storageos-2               running (virtualbox)
storageos-3               running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```
## Checking the Installation

Based on the default Vagrantfile paramaters you will see 8 vdi volumes allocated to each node:

```text
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

To remote shell into the cluster you should use the `vagrant ssh` command and sepcify the node you wish to connect in the case of a multi-node cluster setup:

```text
StorageOS:storageos julian$ vagrant ssh storageos-1
Welcome to Ubuntu 16.04.1 LTS (GNU/Linux 4.4.0-21-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
vagrant@storageos-1:~$
```

Running the `docker ps` command will display what is currently running on the node:

```text
vagrant@storageos-1:~$ docker ps -a
CONTAINER ID  IMAGE                                 COMMAND                  CREATED          STATUS                     PORTS   NAMES
7249d2fd369e  quay.io/storageos/controlplane:alpha  "/bin/storageos datap"   35 minutes ago   Exited (0) 35 minutes ago          storageos_data_1
6d26930d9b32  consul:v0.6.4                         "docker-entrypoint.sh"   35 minutes ago   Up 35 minutes                      consul
```

To disconnect your session simply type `Ctrl + D` to return back to your original shell prompt:

```text
vagrant@storageos-1:~$ logout
Connection to 127.0.0.1 closed.
StorageOS:storageos julian$
```

## Troubleshooting the Installation

With the Vagrant build sometimes StorageOS doesn't start properly or start at all.  On occasions consul may not have started either.  In this case it will be necessary to check the running status of the containers on each of your newly provisioned StorageOS Vagrant host.


```text
StorageOS:storageos julian$ vagrant ssh storageos-2
Welcome to Ubuntu 16.04.1 LTS (GNU/Linux 4.4.0-21-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
Last login: Thu Nov 10 12:55:41 2016 from 10.0.2.2
vagrant@storageos-2:~$ docker ps -a
CONTAINER ID  IMAGE          COMMAND                 CREATED         STATUS         PORTS    NAMES
53fb97d39903  consul:v0.6.4  "docker-entrypoint.sh"  59 minutes ago  Up 59 minutes           consul
```

In this example Vagrant has failed to start StorageOS properly and it will be necessary to get the dataplane and controlplane restarted.

```text
root@storageos-2:~# storageos start
Pulling data (quay.io/storageos/controlplane:alpha)...
alpha: Pulling from storageos/controlplane
f794c1176293: Pull complete
3e5338dad32b: Pull complete
314b32cad781: Pull complete
Digest: sha256:b73de9eb789f47f0d8205ea8afa3ec910d6f240eff439563f8051e3a84e5af15
Status: Downloaded newer image for quay.io/storageos/controlplane:alpha
Creating storageos_data_1
Pulling influxdb (quay.io/storageos/influxdb:alpha)...
alpha: Pulling from storageos/influxdb
a3ed95caeb02: Pull complete
300273678d06: Pull complete
5e0c3915d9ff: Pull complete
8e8fd77e64a2: Pull complete
6a4cf0a00deb: Pull complete
Digest: sha256:202c48f3e0223e56909a9118aab784c5b1fe3984e183552be76bb44c2900da81
Status: Downloaded newer image for quay.io/storageos/influxdb:alpha
Creating storageos_influxdb_1
Creating storageos_control_1
```

Sometimes StorageOS still won't start and it will be necessary to remove the StorageOS Docker image and start again

```text
root@storageos-3:~# storageos start
Pulling data (quay.io/storageos/controlplane:alpha)...
alpha: Pulling from storageos/controlplane
f794c1176293: Pull complete
3e5338dad32b: Pull complete
314b32cad781: Pull complete
Digest: sha256:b73de9eb789f47f0d8205ea8afa3ec910d6f240eff439563f8051e3a84e5af15
Status: Downloaded newer image for quay.io/storageos/controlplane:alpha
Creating storageos_data_1
Pulling influxdb (quay.io/storageos/influxdb:alpha)...
ERROR: read tcp 10.0.2.15:54794->54.235.104.1:443: read: connection reset by peer
root@storageos-3:~# storageos start
Pulling influxdb (quay.io/storageos/influxdb:alpha)...
ERROR: read tcp 10.0.2.15:56546->54.243.130.124:443: read: connection reset by peer
```

Stop and remove StorageOS

```text
root@storageos-3:~# docker ps -a
CONTAINER ID        IMAGE                                  COMMAND                  CREATED             STATUS                      PORTS               NAMES
59bd3226d150        quay.io/storageos/controlplane:alpha   "/bin/storageos datap"   35 seconds ago      Up 34 seconds (unhealthy)                       storageos_data_1
01640ec9b15e        consul:v0.6.4                          "docker-entrypoint.sh"   About an hour ago   Up 7 minutes                                    consul
root@storageos-3:~# docker stop 59bd3226d150
59bd3226d150
root@storageos-3:~# docker rm 59bd3226d150
59bd3226d150
```

Remove StorageOS image

```text
root@storageos-3:~# docker images
REPOSITORY                       TAG                 IMAGE ID            CREATED             SIZE
consul                           v0.6.4              b0971c9ec426        3 weeks ago         32.44 MB
quay.io/storageos/controlplane   alpha               659de31e983d        7 weeks ago         41.17 MB

root@storageos-3:~# docker rmi 659de31e983d
Untagged: quay.io/storageos/controlplane:alpha
Untagged: quay.io/storageos/controlplane@sha256:b73de9eb789f47f0d8205ea8afa3ec910d6f240eff439563f8051e3a84e5af15
Deleted: sha256:659de31e983d0e7772975d8f2c341f0803aa37bd28a2cb890404fd8c43d531fd
Deleted: sha256:ce9b1b8e6c20bd44c29e55a6b632b20476dff6e3b66cbea67089757cdac5e3e9
Deleted: sha256:e85b28522ccfb439cb81a2cad693f5d6f63f3ab20b8616fdb90c81da1dce93fb
Deleted: sha256:e8c82ee2e9341d06e1afc4ace4347cab6753edcba60a928d46cfae5a73e6359d
```

Restart StorageOS container

```text
root@storageos-3:~# storageos start
```


Confirm status of the StorageOS container

```text
root@storageos-2:~# docker ps -a
CONTAINER ID        IMAGE                                  COMMAND                  CREATED             STATUS                   PORTS                                                                                                           NAMES
c7e04f9f7972        quay.io/storageos/controlplane:alpha   "/bin/storageos serve"   9 minutes ago       Up 9 minutes (healthy)   0.0.0.0:4222->4222/tcp, 0.0.0.0:8000->8000/tcp, 0.0.0.0:8222->8222/tcp, 0.0.0.0:80->8000/tcp                    storageos_control_1
5c28f3cfae0e        quay.io/storageos/influxdb:alpha       "influxd --config /et"   9 minutes ago       Up 9 minutes             2003/tcp, 4242/tcp, 8083/tcp, 8088/tcp, 25826/tcp, 8086/udp, 0.0.0.0:8086->8086/tcp, 0.0.0.0:25826->25826/udp   storageos_influxdb_1
28e5108cf8dd        quay.io/storageos/controlplane:alpha   "/bin/storageos datap"   9 minutes ago       Up 9 minutes (healthy)                                                                                                                   storageos_data_1
53fb97d39903        consul:v0.6.4                          "docker-entrypoint.sh"   About an hour ago   Up About an hour                                                                                                                         consul
```

In addition consul may have stalled on startup and needs to be restarted.

```text
vagrant@storageos-3:~$ docker restart consul
consul
vagrant@storageos-3:~$ docker ps -a
CONTAINER ID  IMAGE          COMMAND                 CREATED            STATUS        PORTS    NAMES
01640ec9b15e  consul:v0.6.4  "docker-entrypoint.sh"  About an hour ago  Up 6 seconds           consul
```

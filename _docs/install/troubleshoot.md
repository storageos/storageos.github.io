---
layout: guide
title: Troubleshooting guide
anchor: install
module: install/troubleshoot
---

# <a name="Troubleshooting Guide"></a> Troubleshooting Guide

In this section we have tried to identidy any potential problems you might encounter and come up with some workarounds. More often than not the issues you may encounter will be related to the Vagrant build where on occasion StorageOS doesn't start properly or consul does not start for one reason or another.

It is also possible that you may encounter problems with the ISO build as well though this install is much less prone to problems with our Beta release.

## Connecting to your StorageOS node

To check the running status of the containers on each of your newly provisioned StorageOS hosts you will need to use a secure shell client such as a terminal window or PuTTY if you are using windows.

### Connect to an ISO install StorageOS node

To connect to an ISO install StorageOS node simply ssh from the terminal.

```bash
storageos:~ julian$ ssh -l storageos 10.1.5.171
storageos@10.1.5.171's password:
Welcome to Ubuntu 16.04 LTS (GNU/Linux 4.4.0-21-generic x86_64)

 * Documentation:  https://help.ubuntu.com/
Last login: Tue Nov 15 17:40:31 2016 from 10.1.5.170
storageos@storageos-01:~$
```

### Connect to a Vagrant install StorageOS node

To connect to a Vagrant install StorageOS node simply use `vagrant ssh` from the vagrant machine folder where you started your Vagrant cluster from.

```bash
storageos:storageos julian$ vagrant ssh storageos-1
Welcome to Ubuntu 16.04.1 LTS (GNU/Linux 4.4.0-21-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
vagrant@storageos-1:~$
```


## Elevate your privileges

Once connected, you will want to elevate your privilege level to run most of the commands discussed below:

```bash
storageos@storageos-03:~$ sudo -i
[sudo] password for storageos:
root@storageos-03:~#
```

## Confirming and restarting the Docker service

More often than not, if you think there is a problem, its most likely going to be related to your Docker containers but before you check these you should check the status of Docker first.

One easy way to do this is to look at the status of the Docker service - you will quickly know if there is a problem and you can attempt to restart the docker service with 'service docker start'

```bash
root@storageos-1:~# service docker status | grep Active
   Active: inactive (dead) since Wed 2016-11-16 14:17:32 UTC; 50s ago
root@storageos-1:~# service docker start
root@storageos-1:~# service docker status | grep Active
   Active: active (running) since Wed 2016-11-16 14:19:06 UTC; 3s ago
```

Also, simply running a docker command should provide sufficient feedback on its running state.

```bash
root@storageos-03:~# docker ps -a
Cannot connect to the Docker daemon. Is the docker daemon running on this host?
```

## Docker service will not restart

If you are unable to restart the Docker service with `service docker start` you may have recieved a more serious error:

```bash
root@storageos-1:~# service docker status | grep Active
   Active: failed (Result: exit-code) since Wed 2016-11-16 11:42:03 GMT; 9min ago
```

At this point we strongly suggest you stop troubleshooting and rebuild as it will likely save you a lot of time.

###  Vagrant VM romoval

For Vagrant use the `vagrant destroy` command from the working Vagrant build directory that the cluster resides in and remove all the Vagrant instances as these can be quickly re-established:

```bash
storageos:storageos julian$ vagrant destroy
    storageos-3: Are you sure you want to destroy the 'storageos-3' VM? [y/N] y
==> storageos-3: Destroying VM and associated drives...
    storageos-2: Are you sure you want to destroy the 'storageos-2' VM? [y/N] y
==> storageos-2: Destroying VM and associated drives...
    storageos-1: Are you sure you want to destroy the 'storageos-1' VM? [y/N] y
==> storageos-1: Destroying VM and associated drives...
storageos:storageos julian$
```

###  ISO VM romoval

For the ISO install you should delete the VM that is not working.  Do not attempt to re-install the ISO over the existing VMI.

1. From the VirtualBox application, right-click on the VirtualBox VM you want to delete and select **remove**.

    <img src="/images/docs/iso/vbremove.png" width="360">

2. A dialogue box will appear asking if you want to remove the following virtual machines.  Accept by clicking on the ![Create](/images/docs/iso/vbdeleteall.png) button to completely remove the VM for a fresh install.

    <img src="/images/docs/iso/vbremoveall.png" width="400">


## Docker container state

To check the running state of your Docker containers log into each of the recently build machines and confirm the running status of your Docker containers using the `docker ps -a` command.

### Establishing general system health

**Healthy System**

```bash
storageos@storageos-02:~$ docker ps -a
CONTAINER ID  IMAGE                              COMMAND                  CREATED        STATUS                  PORTS                                                                                                           NAMES
4dff1fa7eec2  consul:latest                      "docker-entrypoint.sh"   4 minutes ago  Up 3 minutes                                                                                                                            consul
3419a5cd1947  quay.io/storageos/storageos:beta   "/bin/storageos boots"   12 days ago    Exited (0) 12 days ago                                                                                                                  storageos_cli_run_1
1ae8a05b15db  quay.io/storageos/storageos:beta   "/bin/storageos contr"   12 days ago    Up 3 minutes            0.0.0.0:4222->4222/tcp, 0.0.0.0:8000->8000/tcp, 0.0.0.0:8222->8222/tcp, 0.0.0.0:80->8000/tcp                    storageos_control_1
3dd074c85fbd  quay.io/storageos/influxdb:beta    "influxd --config /et"   12 days ago    Up 3 minutes            2003/tcp, 4242/tcp, 8083/tcp, 8088/tcp, 25826/tcp, 8086/udp, 0.0.0.0:8086->8086/tcp, 0.0.0.0:25826->25826/udp   storageos_influxdb_1
87e86b1b434e  quay.io/storageos/storageos:beta   "/bin/storageos datap"   12 days ago    Up 4 minutes                                                                                                                            storageos_data_1
```

**Not-so Healthy System**

```bash
vagrant@storageos-2:~$ docker ps -a
CONTAINER ID  IMAGE          COMMAND                 CREATED         STATUS         PORTS    NAMES
53fb97d39903  consul:v0.6.4  "docker-entrypoint.sh"  59 minutes ago  Up 59 minutes           consul
```

### Start the StorageOS dataplane and controlplane

In this example Vagrant has failed to start StorageOS properly and it will be necessary to get the dataplane and controlplane restarted.

```bash
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

### Restart the StorageOS dataplance and controlplane

Another problem that may occur is when the dataplane and/or controlplane are in an unhealthy state.  In this case running `storageos restart` should resolve the issue.  If for any reasin only one of the services has been restored to a healthy state, run the command for a second time.

```
vagrant@storageos-3:~$ docker ps -a
CONTAINER ID        IMAGE                                  COMMAND                  CREATED             STATUS                     PORTS                                                                                                           NAMES
a21949a6db32        quay.io/storageos/controlplane:alpha   "/bin/storageos boots"   3 minutes ago       Exited (0) 3 minutes ago                                                                                                                   storageos_cli_run_1
7d919f007f0b        consul:v0.6.4                          "docker-entrypoint.sh"   3 minutes ago       Up 3 minutes                                                                                                                               consul
273354a47790        quay.io/storageos/controlplane:alpha   "/bin/storageos serve"   11 minutes ago      Up 3 minutes (unhealthy)   0.0.0.0:4222->4222/tcp, 0.0.0.0:8000->8000/tcp, 0.0.0.0:8222->8222/tcp, 0.0.0.0:80->8000/tcp                    storageos_control_1
d7d3137a78ce        quay.io/storageos/influxdb:alpha       "influxd --config /et"   11 minutes ago      Up 3 minutes               2003/tcp, 4242/tcp, 8083/tcp, 8088/tcp, 25826/tcp, 8086/udp, 0.0.0.0:8086->8086/tcp, 0.0.0.0:25826->25826/udp   storageos_influxdb_1
fe9f938ea612        quay.io/storageos/controlplane:alpha   "/bin/storageos datap"   4 hours ago         Up 3 minutes (unhealthy)                                                                                                                   storageos_data_1
```

### Reinstall the StorageOS Docker image

1.  Sometimes StorageOS still won't start and it will be necessary to remove the StorageOS Docker image and start again

    ```bash
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

2.  Stop and remove StorageOS

    ```bash
    root@storageos-3:~# docker ps -a
    CONTAINER ID        IMAGE                                  COMMAND                  CREATED             STATUS                      PORTS               NAMES
    59bd3226d150        quay.io/storageos/controlplane:alpha   "/bin/storageos datap"   35 seconds ago      Up 34 seconds (unhealthy)                       storageos_data_1
    01640ec9b15e        consul:v0.6.4                          "docker-entrypoint.sh"   About an hour ago   Up 7 minutes                                    consul
    root@storageos-3:~# docker stop 59bd3226d150
    59bd3226d150
    root@storageos-3:~# docker rm 59bd3226d150
    59bd3226d150
    ```

3.  Remove StorageOS image

    ```bash
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

4.  Restart StorageOS container

    ```bash
    root@storageos-3:~# storageos start
    ```

5.  Confirm status of the StorageOS container

    ```bash
    root@storageos-2:~# docker ps -a
    CONTAINER ID        IMAGE                                  COMMAND                  CREATED             STATUS                   PORTS                                                                                                           NAMES
    c7e04f9f7972        quay.io/storageos/controlplane:alpha   "/bin/storageos serve"   9 minutes ago       Up 9 minutes (healthy)   0.0.0.0:4222->4222/tcp, 0.0.0.0:8000->8000/tcp, 0.0.0.0:8222->8222/tcp, 0.0.0.0:80->8000/tcp                    storageos_control_1
    5c28f3cfae0e        quay.io/storageos/influxdb:alpha       "influxd --config /et"   9 minutes ago       Up 9 minutes             2003/tcp, 4242/tcp, 8083/tcp, 8088/tcp, 25826/tcp, 8086/udp, 0.0.0.0:8086->8086/tcp, 0.0.0.0:25826->25826/udp   storageos_influxdb_1
    28e5108cf8dd        quay.io/storageos/controlplane:alpha   "/bin/storageos datap"   9 minutes ago       Up 9 minutes (healthy)                                                                                                                   storageos_data_1
    53fb97d39903        consul:v0.6.4                          "docker-entrypoint.sh"   About an hour ago   Up About an hour                                                                                                                         consul
    ```

### StorageOS still doesn't restart

Another issue that may arise is receiving the following error after unsuccessfully restarting the StrageOS container.

```bash
ERROR: failed to register layer: rename /var/lib/docker/image/aufs/layerdb/tmp/layer-176027139 /var/lib/docker/image/aufs/layerdb/sha256/b3aef0b33ad82176867819248a8d54e06233ecd62c7147a8c864060dd6d904d9: directory not empty
```

To resolve this problem simply delerte the sha256 directory.

```bash
root@storageos-03:~# rm -rf /var/lib/docker/image/aufs/layerdb/sha256/
```

Then restart the StorageOS container.

```bash
root@storageos-03:~# storageos start
Pulling influxdb (quay.io/storageos/influxdb:beta)...
beta: Pulling from storageos/influxdb
a3ed95caeb02: Pull complete
300273678d06: Pull complete
5e0c3915d9ff: Pull complete
8e8fd77e64a2: Pull complete
6a4cf0a00deb: Pull complete
Digest: sha256:bf6168db0ecfdadbce622a718b9c6ad516e7c685ea3cc28850cebdeadcff221f
Status: Image is up to date for quay.io/storageos/influxdb:beta
Creating storageos_influxdb_1
Creating storageos_control_1
```

### Restarting consul

On occasions it is possible consul may have stalled on startup and needs to be restarted.

```bash
vagrant@storageos-3:~$ docker restart consul
consul
vagrant@storageos-3:~$ docker ps -a
CONTAINER ID  IMAGE          COMMAND                 CREATED            STATUS        PORTS    NAMES
01640ec9b15e  consul:v0.6.4  "docker-entrypoint.sh"  About an hour ago  Up 6 seconds           consul
```

If however consul has failed to install it will need to be installed.

```bash
root@storageos-03:~# docker pull consul
Using default tag: latest
latest: Pulling from library/consul
3690ec4760f9: Pull complete
ba641cbc2e36: Pull complete
2a0885c9cb15: Pull complete
8baed0bc57fe: Pull complete
048b29acd8e7: Pull complete
Digest: sha256:4a6a91f7981d2c78b8746075859a2ff5ae938bae5da3b9b5637714fc7810fbb2
Status: Downloaded newer image for consul:latest
```

If consul still doesn't install with ```docker pull consul``` then a `vagrant reload` should reolve this problem.

```bash
vagrant@storageos-1:~$ docker pull consul
Using default tag: latest
latest: Pulling from library/consul
3690ec4760f9: Downloading [=====>                                             ]   256 kB/2.313 MB
ba641cbc2e36: Download complete
2a0885c9cb15: Downloading [=>                                                 ] 290.7 kB/9.182 MB
8baed0bc57fe: Waiting
048b29acd8e7: Waiting
error pulling image configuration: Get https://dseasb33srnrn.cloudfront.net/registry-v2/docker/registry/v2/blobs/sha256/40/40d2b6c205a626671dcadf5dd342884a95fde30731c6011bfd4c586637d62c0b/data?Expires=1479385136&Signature=b8xit2KaqDCxVKBEKBnAL7X-erGEkACDPMYELPNuYGoneysX7B0~cpV80FRvvVjeKbiew0sTOyyGZDERI0B4jCjQ5B7DJciwGI7MfqMV~mlw8tiywNp902revkNDmOTkpq7roz8Gp6WSVevZEH2mN3hPDh5Lw6vBSRpn-kzAC-Q_&Key-Pair-Id=APKAJECH5M7VWIS5YZ6Q: read tcp 10.0.2.15:37838->54.230.11.194:443: read: connection reset by peer

vagrant@storageos-1:~$ logout
Connection to 127.0.0.1 closed.
storageos:storageos julian$ vagrant reload
```

Finally `consul` will need to be started

```bash
root@storageos-03:~# systemctl start consul
```

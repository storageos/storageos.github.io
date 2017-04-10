---
layout: guide
title: Quick start
anchor: introduction
module: introduction/quick_start
---

# Quick start

The fastest way to try out StorageOS is to download the plugin from the Docker Hub.

During beta, StorageOS requires 64-bit Linux to run. Windows or MacOS users should install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant](http://vagrantup.com/downloads.html), then create an Ubuntu box and ssh into it:
```bash
$ vagrant init bento/ubuntu-16.04
$ vagrant up
$ vagrant ssh
```

If you don't have Docker installed, get the latest version:
```
curl -sSL https://get.docker.com | sudo sh
```

### Single node install

1. Install StorageOS from the Docker hub.
```bash
$ sudo docker plugin install --grant-all-permissions --alias storageos storageos/plugin KV_BACKEND=boltdb
```
* `--grant-all-permissions`: Remove this to view requested permissions.
* `--alias storageos storageos/plugin`: Allows you to specify `--volume-driver storageos` when starting containers.
* `KV_BACKEND`: Use the built-in key/value store for testing.

2. That's it - StorageOS is now running. Confirm that Docker has installed the plugin:
```bash
$ sudo docker plugin ls
ID                  NAME                DESCRIPTION                   ENABLED
638e7e013325        storageos:latest    StorageOS plugin for Docker   true
```

3. Use the volume plugin:
```bash
$ sudo docker run -it --rm --volume-driver storageos -v test01:/data alpine sh -c "echo hello > /data/myfile"
```
* `-it`: Allocate a tty
* `--rm`: Clean up container file system on exit
* `--volume-driver storageos`: Use the StorageOS volume driver.
* `-v test01:/data`: Create a volume called `test01` and mount it at `/data`
* `alpine sh -c`: Launch a bash shell inside a lightweight linux distribution.
* `echo hello > /data/myfile`: Write a test file.

4. Inspect the data volume, then read the contents of `/data/myfile` from a different container.
```bash
$ sudo docker volume inspect test01
[
    {
        "Driver": "storageos:latest",
        "Labels": null,
        "Mountpoint": "/export/b37f6b3b-7864-e123-12b1-c513de104af3",
        "Name": "test01",
        "Options": {},
        "Scope": "global"
    }
]
$ sudo docker run -it --rm --volume-driver storageos -v test01:/data alpine sh -c "cat /data/myfile"
hello
```

If you are using Vagrant, exit and clean up the Vagrant box.
```bash
$ exit
$ vagrant destroy
```

### Cluster install

To test high availability, install StorageOS on a three node cluster.

1. If you are on a laptop or single machine, set up a test cluster using Vagrant.
    1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant](http://vagrantup.com/downloads.html).

    2. ```vagrant init bento/ubuntu-16.04```

2. TODO (Docker, Consul set up)


4. Download the StorageOS CLI from Github. and confirm that StorageOS has provisioned a 10GB volume to `/data` in the container:
```bash
$ curl -sSL https://github.com/storageos/go-cli/releases/download/v0.0.1/storageos_linux_amd64 > storageos
$ chmod +x storageos
$ ./storageos -u storageos -p storageos volume list
NAMESPACE/NAME      SIZE                MOUNTED BY          STATUS
default/test01      10GB                                    active
```
**Note**: The default installation has one user with username and password `storageos`, which is passed via the -u and -p flags.


### Stay in touch

Sign up to the [customer portal](http://my.storageos.com) to stay informed about upcoming releases, then join the [StorageOS Slack channel](http://slack.storageos.com).

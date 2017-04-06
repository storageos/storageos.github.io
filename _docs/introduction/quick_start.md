---
layout: guide
title: Quick start
anchor: introduction
module: introduction/quick_start
---

# Quick start

The easiest way to test StorageOS is to download the plugin from the Docker Hub.

During beta, StorageOS requires 64-bit Linux to run. Windows or MacOS users should install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant](http://vagrantup.com/downloads.html), then create an Ubuntu box and ssh into it:
```bash
$ vagrant init bento/ubuntu-16.04
$ vagrant up
$ vagrant ssh
```

### Single node install

1. Install the latest Docker engine.
```
curl -sSL https://get.docker.com | sh
```
2. Install StorageOS from the Docker hub.
```bash
$ sudo docker plugin install --alias storageos storageos/plugin KV_BACKEND=boltdb
```
**Note**: The alias flag allows you to specify `--volume-driver storageos` when starting containers. KV_BACKEND specifies the built-in key/value store for testing.

3. Create a volume and mount it.
```bash
$ sudo docker run -it --rm --name test01 --volume-driver storageos -v test01:/data alpine ash -i
/ # echo hello > /data/myfile
/ # exit
```

4. Download the CLI from github.
```bash
curl -sSL https://github.com/storageos/go-cli/releases/download/v0.0.1/storageos_linux_amd64 > storageos
chmod +x storageos
```

4. That's it - StorageOS is now running. Confirm that StorageOS has provisioned a 10GB volume to `/data` in the container:
```bash
$ ./storageos volume list
```

5. Clean up the Vagrant box.
```bash
$ vagrant destroy
```

### Cluster install

To test high availability, install StorageOS on a three node cluster.

1. If you are on a laptop or single machine, set up a test cluster using Vagrant.
    1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant](http://vagrantup.com/downloads.html).

    2. ```vagrant init bento/ubuntu-16.04```

2. TODO (Docker, Consul set up)


### Get a license

To remove the 100GB storage capacity limit on unregistered users, sign up for a free developer license from the [customer portal](http://my.storageos.com).

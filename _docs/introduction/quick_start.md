---
layout: guide
title: Quick start
anchor: introduction
module: introduction/quick_start
---

# Quick start

The fastest and easiest way is to get up and running with StorageOS is to run a local install ie. on a single node. StorageOS needs 64-bit Linux to run.

* Windows or MacOS users: first install VirtualBox and [Vagrant 1.9.1](http://vagrantup.com/downloads.html), then create an Ubuntu box and ssh into it:
```bash
$ vagrant init ubuntu/xenial64
$ vagrant up
$ vagrant ssh
```

* Install the latest Docker engine following Step 1 from [this guide](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04).

* Install StorageOS.
```bash
$ sudo mkdir /var/lib/storageos
$ sudo docker plugin install storageos/plugin KV_BACKEND=boltdb
```

* That's it - StorageOS is now running and provisioning a 10GB volume at xxxx. To confirm, run
```bash
$ storageos volume list
```

* Exit the SSH session and remove the Vagrant box, if using.
```bash
$ exit
$ vagrant destroy
```

## Next steps

StorageOS should be installed on a cluster of machines so that data can be replicated across nodes.
```bash
TODO
```

### Get a license

To remove the 100GB storage capacity limit on unregistered users, sign up for a free developer license from the [customer portal](http://my.storageos.com).

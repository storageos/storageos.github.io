---
layout: guide
title: Cluster install
anchor: install
module: install/cluster install
# Last reviewed by cheryl.hung@storageos.com on 2017-04-11
---

# Cluster install

To test high availability, set up a three node StorageOS cluster using a laptop or single machine.

## Prerequisites

Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant
1.9.3](http://vagrantup.com/downloads.html).

## Installation

1. Clone this repository, which contains scripts to automate setup.
```bash
$ mkdir storageos-cluster
$ cd storageos-cluster
$ git clone https://github.com/andrelucas/storageos-alpine.git
```

2. Bring up a three-node StorageOS cluster.
```bash
$ vagrant plugin install vagrant-alpine
$ make all
Bringing machine 's-1' up with 'virtualbox' provider...
Bringing machine 's-2' up with 'virtualbox' provider...
Bringing machine 's-3' up with 'virtualbox' provider...
[...]
```
This sets up three virtual machines named `s-1`, `s-2`, `s-3` running
* Alpine Linux
* Docker
* The recommended KV store, Consul.
* The StorageOS volume plugin.

3. Connect to one of the VMs:
```bash
$ vagrant ssh s-1
```

4. Install the StorageOS CLI.
```bash
$ curl -sSL https://github.com/storageos/go-cli/releases/download/v0.0.2/storageos_linux_amd64 > storageos
$ chmod +x storageos
$ export STORAGEOS_USERNAME=storageos STORAGEOS_PASSWORD=storageos STORAGEOS_HOST=127.0.0.1
$ export PATH=$PATH:.
```
* By default StorageOS starts with a single user with username `storageos` and password `storageos`.

Now you are ready to [install an application](../applications/postgres.html) or [manage the cluster](../manage/volumes.html).

To log into other nodes:
```bash
$ exit
$ vagrant ssh s-2
```

To clean up:
```bash
$ exit
$ vagrant destroy
```

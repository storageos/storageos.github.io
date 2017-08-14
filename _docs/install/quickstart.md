---
layout: guide
title: StorageOS Docs - Quick start
anchor: install
module: install/quickstart
---

# Quick start

To quickly test StorageOS on a laptop, you can run a cluster locally using
Vagrant.

You will need to install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
and [Vagrant 1.9.3](http://vagrantup.com/downloads.html).


## Installation

Download the [Vagrantfile](https://docs.storageos.com/assets/Vagrantfile) and
run `vagrant up` to provision three Ubuntu 16.04 VMs running Docker, the
StorageOS container, and the StorageOS CLI.

```bash
$ sudo wget https://docs.storageos.com/assets/Vagrantfile
$ vagrant up
Bringing machine 'storageos-1' up with 'virtualbox' provider...
Bringing machine 'storageos-2' up with 'virtualbox' provider...
Bringing machine 'storageos-3' up with 'virtualbox' provider...
...

```

Now you are ready to [manage volumes]({% link _docs/manage/volumes/index.md %})
or [install Postgres]({% link _docs/applications/databases/postgres.md %}).

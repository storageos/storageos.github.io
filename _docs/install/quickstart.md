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

Download the [Vagrantfile]({%link assets/Vagrantfile %}) and
run `vagrant up` to provision three Ubuntu 16.04 VMs running Docker, the
StorageOS container, and the StorageOS CLI.

```bash
$ curl -sS https://docs.storageos.com/assets/Vagrantfile -o Vagrantfile
$ vagrant up
Bringing machine 'storageos-1' up with 'virtualbox' provider...
Bringing machine 'storageos-2' up with 'virtualbox' provider...
Bringing machine 'storageos-3' up with 'virtualbox' provider...
...
==> storageos-3: c2bda12c8025: Pull complete
==> storageos-3: Digest: sha256:f9201f8a417eec88f0e417576442e4daecb552310f3eeda2b0676145203b1ea8
==> storageos-3: Status: Downloaded newer image for storageos/node
==> storageos-3: e91abf267c3f6d4dee8aaa31b3a233329d3a6e905ae83578b9bd2c59c32f5661
```

## SSH into the VMs

First confirm that all three VMs are up and running.

```bash
$ vagrant status
Current machine states:

storageos-1               running (virtualbox)
storageos-2               running (virtualbox)
storageos-3               running (virtualbox)
```

Next, connect to a VM as shown below.
```bash
$ vagrant ssh storageos-1
...
vagrant@storageos-1:~$
```

Now you are ready to [manage volumes]({% link _docs/manage/volumes/index.md %})
or [install Postgres]({% link _docs/applications/databases/postgres.md %}).

__NOTE__: If due to some reason, the storageos containers stop, they can be
restarted by running `docker start storageos`.

__NOTE__: When finished with the VMs, you can terminate them with `vagrant destroy`
---
layout: guide
title: StorageOS Docs - Quick start
anchor: install
module: install/quickstart
# Last reviewed by simon.croome@storageos.com on 2017-04-11
---

# Quick start

To quickly test StorageOS on a laptop, you can set up a three node cluster using Vagrant.

You will need to install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant
1.9.3](http://vagrantup.com/downloads.html). You will also need the Vagrant
plugin for Alpine, a lightweight Linux distribution:

```bash
vagrant plugin install vagrant-alpine
```

## Installation

1. Get the setup needed for a three-node StorageOS cluster:

    ```bash
    git clone https://github.com/storageos/storageos-alpine.git
    cd storageos-alpine
    ```

1. Bring up the cluster. This takes around five minutes.

    ```bash
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

1. Connect to one of the VMs

    ```bash
    vagrant ssh s-1
    ```

Now you are ready to [manage volumes]({% link _docs/manage/volumes/index.md %}) or [install Postgres]({% link _docs/applications/databases/postgres.md %}).

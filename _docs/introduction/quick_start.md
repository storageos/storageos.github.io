---
layout: guide
title: Quick start
anchor: introduction
module: introduction/quick_start
---

# Quick start

The fastest way to try out StorageOS is to download the plugin from the Docker
Hub.

During beta, StorageOS requires 64-bit Linux to run. Windows or MacOS users
should install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant](http://vagrantup.com/downloads.html), then create an Ubuntu box and
ssh into it:

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
0.7.2: Pulling from storageos/plugin
ff866c314f8c: Download complete
Digest: sha256:759bcc3dfa7b76bf555307a332ff7db9358e63eae681487bde81bf3860af9067
Status: Downloaded newer image for storageos/plugin:0.7.2
Installed plugin storageos/plugin:0.7.2
```
* `--grant-all-permissions`: Remove this to view requested permissions.
* `--alias storageos storageos/plugin`: Allows you to specify `--volume-driver storageos` when starting containers.
* `KV_BACKEND`: Use the built-in key/value store for testing.

2. That's it - StorageOS is now running. Confirm that StorageOS installed successfully.
```bash
$ sudo docker plugin ls
ID                  NAME                DESCRIPTION                   ENABLED
638e7e013325        storageos:latest    StorageOS plugin for Docker   true
```

3. Write data using the StorageOS volume driver.
```bash
$ sudo docker run -it --rm --volume-driver storageos -v test01:/data alpine sh -c "echo hello > /data/myfile"
Unable to find image 'alpine:latest' locally
latest: Pulling from library/alpine
627beaf3eaaf: Pull complete
Digest: sha256:58e1a1bb75db1b5a24a462dd5e2915277ea06438c3f105138f97eb53149673c4
Status: Downloaded newer image for alpine:latest
```
* `-it`: Allocate a tty.
* `--rm`: Clean up container file system on exit.
* `--volume-driver storageos`: Use the StorageOS volume driver.
* `-v test01:/data`: Create a volume called `test01` and mount it at `/data`.
* `alpine sh -c`: Launch a bash shell using Alpine, a lightweight Linux distribution.
* `echo hello > /data/myfile`: Write some text to `/data/myfile`.

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

To test high availability, set up a test StorageOS cluster using a laptop or single machine.

1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant
1.9.3](http://vagrantup.com/downloads.html).

2. Clone this repository, which contains scripts to automate setup.
```bash
$ mkdir storageos-cluster
$ cd storageos-cluster
$ git clone https://github.com/andrelucas/storageos-alpine.git
```

3. Bring up a three-node StorageOS cluster.
```bash
$ vagrant plugin install vagrant-alpine
$ make up
Bringing machine 's-1' up with 'virtualbox' provider...
Bringing machine 's-2' up with 'virtualbox' provider...
Bringing machine 's-3' up with 'virtualbox' provider...
[...]
$ make provision
vagrant provision --provision-with consul-rv
[...]
```
This sets up three virtual machines named `s-1`, `s-2`, `s-3` running
* Alpine Linux
* Docker
* The recommended KV store, Consul.
* The StorageOS volume plugin.

4. Connect to one of the VMs:
```bash
$ vagrant ssh s-1
```

5. Install the StorageOS CLI.
```bash
$ curl -sSL https://github.com/storageos/go-cli/releases/download/v0.0.1/storageos_linux_amd64 > storageos
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

### Stay in touch

Sign up to the [customer portal](http://my.storageos.com) to stay informed about upcoming releases, then join the [StorageOS Slack channel](http://slack.storageos.com).

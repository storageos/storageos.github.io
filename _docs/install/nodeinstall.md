---
layout: guide
title: Node install
anchor: install
module: install/nodeinstall
# Last reviewed by cheryl.hung@storageos.com on 2017-04-10
---

# Node install

## Prerequisites

StorageOS requires 64-bit Linux to run. Windows or MacOS users should install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
and [Vagrant](http://vagrantup.com/downloads.html), then create an Ubuntu box and
ssh into it:

```bash
$ vagrant init bento/ubuntu-16.04
$ vagrant up
$ vagrant ssh
```

This guide describes the plugin install for Docker 1.13+. (For Docker
1.10 to 1.12, see the [container install method](../install/container.html).) To
install the latest version of Docker:
```
curl -sSL https://get.docker.com | sudo sh
```

## Install StorageOS

1. Install StorageOS from the Docker Hub.
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
* `KV_BACKEND`: Use the built-in key/value store for testing. See [docs](../install/kvstore.html).

2. That's it - StorageOS is now running. Confirm successful installation.
```bash
$ sudo docker plugin ls
ID                  NAME                DESCRIPTION                   ENABLED
638e7e013325        storageos:latest    StorageOS plugin for Docker   true
```

3. Write data to a test file using the StorageOS volume driver.
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

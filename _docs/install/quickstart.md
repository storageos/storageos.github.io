---
layout: guide
title: StorageOS Docs - Quick start
anchor: install
module: install/quickstart
---

# Quick start

To quickly test StorageOS on a laptop, you can set up a three node cluster using Vagrant.

You will need to install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant
1.9.3](http://vagrantup.com/downloads.html).


## Installation


1. Mkdir /tmp/test
2. curl Vagrantfile
3. vagrant up
4. vagrant ssh storageos-1
5. docker plugin install --alias storageos --grant-all-permissions soegarots/plugin:c456268 INITIAL_CLUSTER=storageos-1=http://192.168.50.100:2380,storageos-2=http://192.168.50.101:2380,storageos-3=http://192.168.50.102:2380 ADVERTISE_IP=192.168.50.100
6. exit
7. vagrant ssh storageos-2
8. docker plugin install --alias storageos --grant-all-permissions soegarots/plugin:c456268 INITIAL_CLUSTER=storageos-1=http://192.168.50.100:2380,storageos-2=http://192.168.50.101:2380,storageos-3=http://192.168.50.102:2380 ADVERTISE_IP=192.168.50.101
9. exit
10. vagrant ssh storageos-3
11. docker plugin install --alias storageos --grant-all-permissions soegarots/plugin:c456268 INITIAL_CLUSTER=storageos-1=http://192.168.50.100:2380,storageos-2=http://192.168.50.101:2380,storageos-3=http://192.168.50.102:2380 ADVERTISE_IP=192.168.50.102


Now you are ready to [manage volumes]({% link _docs/manage/volumes/index.md %}) or [install Postgres]({% link _docs/applications/databases/postgres.md %}).

---
layout: guide
title: StorageOS Docs - Docker Swarm
anchor: install
module: install/docker/swarm
redirect_from: /docs/install/schedulers/dockerswarm
---

# Docker Swarm

This guide walks you through getting StorageOS set up and running on a Docker Swarm cluster.

## Prerequisites

Install StorageOS containers in your cluster by following the [docker installation procedure]({%link _docs/install/docker/index.md  %}).

## Install 

1. Log into the first StorageOS node and confirm the public facing IP address
   (192.168.50.100 in this example):

   ```bash
   $ ifconfig -a
   ...
   enp0s8    Link encap:Ethernet  HWaddr 08:00:27:1b:97:37
             inet addr:192.168.50.100  Bcast:192.168.50.255  Mask:255.255.255.0
             inet6 addr: fe80::a00:27ff:fe1b:9737/64 Scope:Link
             UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
             RX packets:5146 errors:0 dropped:0 overruns:0 frame:0
             TX packets:5225 errors:0 dropped:0 overruns:0 carrier:0
             collisions:0 txqueuelen:1000
             RX bytes:661870 (661.8 KB)  TX bytes:1109862 (1.1 MB)
   ...
   ```

1. Initialise the Swarm cluster

   ```bash
   $ docker swarm init --advertise-addr 192.168.50.100
   Swarm initialized: current node (59wro1b3wja3zt36wki8dpqcn) is now a manager.

   To add a worker to this swarm, run the following command:

       docker swarm join \
       --token SWMTKN-1-271dopvzgxnmrvtvffd4iexh7xblc49iv9trtt6rajb24fwfkr-4jpzr7yzq12gnh2c6f5nvgwyz \
       192.168.50.100:2377

   To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
   ```
   Continue to the next step, do not join a new node as a worker

1. Generate the join command for additional masters:

   ```bash
   $ docker swarm join-token manager
   To add a manager to this swarm, run the following command:

       docker swarm join \
       --token SWMTKN-1-271dopvzgxnmrvtvffd4iexh7xblc49iv9trtt6rajb24fwfkr-3wbcj986wv2e1d389a8rfhvl1 \
       192.168.50.100:2377
   ```

1. Log on to two new nodes and join the Swarm cluster on each

   *node 2*

   ```bash
   $ docker swarm join \
       --token SWMTKN-1-271dopvzgxnmrvtvffd4iexh7xblc49iv9trtt6rajb24fwfkr-3wbcj986wv2e1d389a8rfhvl1 \
       192.168.50.100:2377
   This node joined a swarm as a manager.
   ```

   *node3*

   ```bash
   $ docker swarm join \
       --token SWMTKN-1-271dopvzgxnmrvtvffd4iexh7xblc49iv9trtt6rajb24fwfkr-3wbcj986wv2e1d389a8rfhvl1 \
       192.168.50.100:2377
   This node joined a swarm as a manager.
   ```

1. Check the node list

   ```bash
   $ docker node ls
   ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS
   id6bcs7lt7i6iroua78rhe3b7 *   storageos-1         Ready               Active              Leader
   l7v3wlksl0xwn4biwej516d8u     storageos-3         Ready               Active              Reachable
   z1hkolqqq6kspunalqyk4c4dg     storageos-2         Ready               Active              Reachable
   ```

    All 3 nodes should be Active and with the status of Leader or Reachable

## Example

Deploy Nginx using driver `storageos`. This deployment will trigger an nginx container with a persistent volume attached to each one of them. 

```bash
cat <<END > ./nginx.yaml
version: '3.4'
services:
    nginx:
      image: nginx
      network_mode: "host"
      pid: "host"
      ports:
        - 80:80
      volumes:
          - data:/usr/share/nginx/html
      deploy:
        mode: global # One container per node
        restart_policy:
          condition: on-failure
volumes:
    data:
        driver: storageos
        name: 'web-{{ "{{.Task.Slot" }}}}'
END
docker stack deploy -c nginx.yaml nginx
```

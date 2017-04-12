---
layout: guide
title: WordPress Demo
anchor: applications
module: applications/wordpress
---

# ![image](/images/docs/explore/wordpresslogo.png) WordPress Cluster Demo

This section will focus on creating a WordPress cluster with persistent storage.  Here we will demonstrate draining and activating a node in the cluster without losing access to the underlying, persistent storage.


## Create a Docker Swarm cluster

The first step in this exercise is to get Docker Swarm set up and running on your test cluster.

1. Log into the first StorageOS node and confirm the public facing IP address (10.245.103.2 in this example):

   ```bash
   $ ifconfig eth1
   eth1      Link encap:Ethernet  HWaddr 08:00:27:e4:f1:73
             inet addr:10.245.103.2  Bcast:10.245.103.255  Mask:255.255.255.0
             inet6 addr: fe80::a00:27ff:fee4:f173/64 Scope:Link
             UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
             RX packets:11590 errors:0 dropped:0 overruns:0 frame:0
             TX packets:16663 errors:0 dropped:0 overruns:0 carrier:0
             collisions:0 txqueuelen:1000
             RX bytes:1803414 (1.8 MB)  TX bytes:4767531 (4.7 MB)
   ```

2. Initialise the Swarm cluster

   ```bash
   $ docker swarm init --advertise-addr 10.245.103.2
   Swarm initialized: current node (59wro1b3wja3zt36wki8dpqcn) is now a manager.

   To add a worker to this swarm, run the following command:

       docker swarm join \
       --token SWMTKN-1-271dopvzgxnmrvtvffd4iexh7xblc49iv9trtt6rajb24fwfkr-4jpzr7yzq12gnh2c6f5nvgwyz \
       10.245.103.2:2377

   To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
   ```

3. Generate the join command for additional masters:

   ```bash
   $ docker swarm join-token manager
   To add a manager to this swarm, run the following command:

       docker swarm join \
       --token SWMTKN-1-271dopvzgxnmrvtvffd4iexh7xblc49iv9trtt6rajb24fwfkr-3wbcj986wv2e1d389a8rfhvl1 \
       10.245.103.2:2377
   ```

4. Log on to other 2 nodes and join swarm cluster on each

   #### node 2:

   ```bash
   $ docker swarm join \
   >     --token SWMTKN-1-271dopvzgxnmrvtvffd4iexh7xblc49iv9trtt6rajb24fwfkr-3wbcj986wv2e1d389a8rfhvl1 \
   >     10.245.103.2:2377
   This node joined a swarm as a manager.
   ```

   #### node3:

   ```bash
   $ docker swarm join \
   >     --token SWMTKN-1-271dopvzgxnmrvtvffd4iexh7xblc49iv9trtt6rajb24fwfkr-3wbcj986wv2e1d389a8rfhvl1 \
   >     10.245.103.2:2377
   This node joined a swarm as a manager.
   ```

6. Check the node list

   ```bash
   $ docker node ls
   ID                           HOSTNAME     STATUS  AVAILABILITY  MANAGER STATUS
   59wro1b3wja3zt36wki8dpqcn *  storageos-01  Ready   Active        Leader
   7v48k86uwk4ef7c04q12j1npa    storageos-03  Ready   Active        Reachable
   ckyz2idmx7m6v18xhyz21i8q9    storageos-02  Ready   Active        Reachable
   ```

All 3 nodes should be Active and with the status of Leader or Reachable

## WordPress and MySQL Docker Swarm

1. Create an overlay network with Docker Engine swarm mode

   ```bash
   $ docker network create --driver overlay wp
   d6j6qds580gocl2t7evdxtd7n
   ```

2. Setup the Percona fork of MySQL server using wp network overlay

   ```bash
   $ docker service create --name db --network wp --publish 3306:3306 \
     --replicas 1 -e MYSQL_ROOT_PASSWORD=wordpress -e MYSQL_DATABASE=wordpress -e \
     MYSQL_USER=wordpress -e MYSQL_PASSWORD=wordpress --mount type=volume,src=db,\
     dst=/var/lib/mysql,volume-driver=storageos percona:5.7 --ignore-db-dir=lost+found
   a91p715zxsepb360q6bearu20
   ```

3. Setup WordPress server using wp network overlay and publish to default port 80 on public facing IPs of swarm nodes

   ```bash
   $ docker service create --name wp --network wp --publish 82:82 --mode \
     global -e WORDPRESS_DB_HOST=db:3306 -e WORDPRESS_DB_PASSWORD=wordpress wordpress:latest
   a16nksbhb8sd5kg3ekcpmn3nn
   ```

   ![screenshot](/images/docs/explore/wordpresssetup.png)

4. Drain and re-active WordPress service on node 1

   ```bash
   $ docker node update --availability drain storageos-01
   ```
   ```bash
   $ docker node update --availability active storageos-01
   ```

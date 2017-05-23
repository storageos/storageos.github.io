---
layout: guide
title: StorageOS Docs - Swarm with Wordpress
anchor: applications
module: applications/wordpress
# Last reviewed by cheryl.hung@storageos.com on 2017-04-12 - commands work fine but can't connect to WP
---

# ![image](/images/docs/explore/wordpresslogo.png) WordPress Cluster Demo

This section will focus on creating a WordPress cluster with persistent storage.  Here we will demonstrate draining and activating a node in the cluster without losing access to the underlying persistent storage.


## Create a Docker Swarm cluster

The first step in this exercise is to get Docker Swarm set up and running on your test cluster.

1. Log into the first StorageOS node and confirm the public facing IP address (192.168.50.100 in this example):

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

2. Initialise the Swarm cluster

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

3. Generate the join command for additional masters:

   ```bash
   $ docker swarm join-token manager
   To add a manager to this swarm, run the following command:

       docker swarm join \
       --token SWMTKN-1-271dopvzgxnmrvtvffd4iexh7xblc49iv9trtt6rajb24fwfkr-3wbcj986wv2e1d389a8rfhvl1 \
       192.168.50.100:2377
   ```

4. Log on to two new nodes and join the Swarm cluster on each

   #### node 2:

   ```bash
   $ docker swarm join \
   >     --token SWMTKN-1-271dopvzgxnmrvtvffd4iexh7xblc49iv9trtt6rajb24fwfkr-3wbcj986wv2e1d389a8rfhvl1 \
   >     192.168.50.100:2377
   This node joined a swarm as a manager.
   ```

   #### node3:

   ```bash
   $ docker swarm join \
   >     --token SWMTKN-1-271dopvzgxnmrvtvffd4iexh7xblc49iv9trtt6rajb24fwfkr-3wbcj986wv2e1d389a8rfhvl1 \
   >     192.168.50.100:2377
   This node joined a swarm as a manager.
   ```

6. Check the node list

   ```bash
   ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS
   id6bcs7lt7i6iroua78rhe3b7 *   storageos-1         Ready               Active              Leader
   l7v3wlksl0xwn4biwej516d8u     storageos-3         Ready               Active              Reachable
   z1hkolqqq6kspunalqyk4c4dg     storageos-2         Ready               Active              Reachable
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
   $ docker service create \
       --mount type=volume,src=db,dst=/var/lib/mysql,volume-driver=storageos \
       --name db \
       --replicas 1 \
       --network wp \
       --publish 3306:3306 \
       --detach=true \
       -e MYSQL_ROOT_PASSWORD=wordpress \
       -e MYSQL_PASSWORD=wordpress \
       -e MYSQL_USER=wordpress \
       -e MYSQL_DATABASE=wordpress \
         percona:5.7 \
       --ignore-db-dir=lost+found
   ```

3. Confirm overlay network, docker service and StorageOS storage have been created
   ```
   $ docker network ls
   NETWORK ID          NAME                DRIVER              SCOPE
   0793c933ca66        bridge              bridge              local
   4f9f784c2791        docker_gwbridge     bridge              local
   5f8f068902d7        host                host                local
   cllpau3m418v        ingress             overlay             swarm
   12f2e944e29d        none                null                local
   kw65yf4pe1j3        wp                  overlay             swarm
   ```
   ```
   $ docker service ls
   ID                  NAME           MODE           REPLICAS       IMAGE          PORTS
   sr32oivdav43        db             replicated     0/1            percona:5.7    *:3306->3306/tcp
   ```
   ```
   $ docker volume ls
   DRIVER              VOLUME NAME
   storageos:latest    db
   ```

4. Setup WordPress server using wp network overlay and publish to default port 80 on public facing IPs of swarm nodes

   ```bash
   $ docker service create \
       --name wp \
       --network wp \
       --publish 80:80 \
       --mode global \
       --detach=true \
       -e WORDPRESS_DB_USER=wordpress \
       -e WORDPRESS_DB_PASSWORD=wordpress \
       -e WORDPRESS_DB_HOST=db:3306 \
       -e WORDPRESS_DB_NAME=wordpress \
        wordpress:latest
   ```
5. Confirm WordPress service is running

   ```
   $ docker service ls
   ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
   sr32oivdav43        db                  replicated          1/1                 percona:5.7         *:3306->3306/tcp
   z6sbs4rju3r5        wp                  global              3/3                 wordpress:latest    *:80->80/tcp
   ```

6. Open a web browser and connect to WordPress setup on any of the 3 nodes

   ![screenshot](/images/docs/explore/wordpresssetup.png)

5. Drain and re-active WordPress service on node 1

   ```bash
   $ docker node update --availability drain storageos-1
   storageos-1
   $ docker service ps wp
   ID                  NAME                           IMAGE               NODE                DESIRED STATE       CURRENT STATE                ERROR               PORTS
   1ywz1k3zfdar        wp.id6bcs7lt7i6iroua78rhe3b7   wordpress:latest    storageos-1         Shutdown            Shutdown 2 minutes ago                       
   sh2yzdyadehu        wp.l7v3wlksl0xwn4biwej516d8u   wordpress:latest    storageos-3         Running             Running 3 minutes ago                        
   w5002v8a9pii        wp.z1hkolqqq6kspunalqyk4c4dg   wordpress:latest    storageos-2         Running             Running 3 minutes ago     
   ```

   WordPress setup should still be available on all three IPs  
   
6. Reactivate WordPress service on node 1
   
   ```
   $ docker node update --availability active storageos-1
   storageos-1
   ID                  NAME                               IMAGE               NODE                DESIRED STATE       CURRENT STATE            ERROR               PORTS
   tpda43ss5a3w        wp.id6bcs7lt7i6iroua78rhe3b7       wordpress:latest    storageos-1         Running             Running 1 about a minute ago                        
   1ywz1k3zfdar         \_ wp.id6bcs7lt7i6iroua78rhe3b7   wordpress:latest    storageos-1         Shutdown            Shutdown 5 minutes ago                       
   sh2yzdyadehu        wp.l7v3wlksl0xwn4biwej516d8u       wordpress:latest    storageos-3         Running             Running 7 minutes ago                        
   w5002v8a9pii        wp.z1hkolqqq6kspunalqyk4c4dg       wordpress:latest    storageos-2         Running             Running 6 minutes ago  
   ```

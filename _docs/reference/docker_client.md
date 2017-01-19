---
layout: guide
title: Docker Client Installation
anchor: reference
module: reference/docker_client
---

# Docker Client Installation

The Docker Client is used to present volumes from a remote StorageOS cluster to containers running on the local Docker host.

In client-only mode, no storage from the local server is added to StorageOS management.

## Requirements

The Docker host should meet the following requirements:

* Recent version of Docker running (1.12.1 recommended).  Note that version 1.12.0 will not work.
* Docker `MountFlags=shared`
* Increase `sysctl fs.inotify.max_user_instances` to `8192`

## Installation

There are a few manual steps that must be run on the host before the StorageOS client will run correctly.

1. Create `/storageos` directory

   `/storageos` needs to exist and be shared.  This directory contains the filesystems that are mounted into Docker containers, as well as the raw volumes and the configuration state.

   ```bash
   mkdir /storageos
   mount -o bind /storageos /storageos
   mount --make-shared /storageos
   ```

2. Configure Docker volume provider

   Docker needs to be configured to use the StorageOS volume plugin.  This is done by writing a configuration file in `/etc/docker/plugins/storageos.json` with contents:

   ```json
   {
     "Name": "storageos",
     "Addr": "unix:////run/docker/plugins/storageos/storageos.sock"
   }
   ```
   This file instructs Docker to use the volume plugin API listening on the specified Unix domain socket.  Note that the socket is only accessible by the root user, and it is only present when the StorageOS client container is running.  

   With the exception of Docker version 1.12.0, the Docker daemon will start correctly without the StorageOS socket available.  This allows StorageOS to run within a container.

3. Set `rshared` Docker flag

   The init file for Docker on some distributions restricts what can be be shared.

   On Linux distributions with `systemd`, add `/etc/systemd/system/docker.service.d/storageos-mount.conf` with contents:

   ```json
   [Service]
   MountFlags=shared
   ```

   Note that you will probably need to create the `/etc/systemd/system/docker.service.d` directory.

   Then reload `systemd` config and restart docker:

   ```bash
   systemctl daemon-reload
   systemctl restart docker
   ```

4. Increase inotify limit

   `inotify`is used by both Docker and StorageOS to immediately react to changes in files without constant polling.  Many Linux distributions have the number of watched files limit set to 128, and "`Too many open files`" messages can begin to appear over time.

   Docker recommends that you increase this limit to 8192.

   Depending on your distribution, you should be able to set with the command:

   ```bash
   sysctl -w fs.inotify.max_user_instances=8192
   ```

   And then to set so that the limit is increased after reboots, create `/etc/sysctl.d/10-inotify.conf` with contents:

   ```json
   fs.inotify.max_user_instances = 8192
   ```

   Linux distributions may vary, so please verify by rebooting.

## Configuration

The client can be configured using flags or environment variables.  All flags have equivalent environment variables (designated in ALL_CAPS).

`--api-addr` / `STORAGEOS_API_ADDR`: &lt;ip address:port&gt; of a running StorageOS cluster node.  On startup, the client will discover the remaining cluster nodes and setup a HA failover group that includes all controller nodes. Defaults to `127.0.0.1:8000`

`--user` / `STORAGEOS_USER`: Username to authenticate to the StorageOS cluster with.  Defaults to `storageos`.

`--password` / `STORAGEOS_PASSWORD`: Password used for authentication to the StorageOS cluster.  Defaults to `storageos`.

## Running

### Docker Run

```bash
$ docker run \
  -e HOSTNAME \
  -e STORAGEOS_API_ADDR=10.245.103.2 \
  -v /storageos:/storageos:rshared \
  -v /run/docker/plugins/storageos:/run/docker/plugins/storageos \
  --device /dev/fuse \
  --ipc host \
  --pid host \
  --privileged \
  --cap-add SYS_ADMIN \
  quay.io/storageos/storageos:beta client
```

### Docker-compose

```yml
version: '2'
services:
 storageos:
   image: quay.io/storageos/storageos:beta
   command: "client"
   restart: never
   privileged: true
   cap_add:
     - "SYS_ADMIN"
   ipc: host
   pid: host
   network_mode: host
   environment:
     - HOSTNAME
     - STORAGEOS_API_ADDR=10.245.103.2
     - STORAGEOS_USER=storageos
     - STORAGEOS_PASSWORD=storageos
   devices:
     - /dev/fuse
   volumes:
     - "/storageos:/storageos:rshared"
     - "/run/docker/plugins/storageos:/run/docker/plugins/storageos"
```

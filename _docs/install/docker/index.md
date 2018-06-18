---
layout: guide
title: StorageOS Docs - Docker container
anchor: install
module: install/docker/container
redirect_from: /docs/install/docker/container
---

# Install with Docker

Install StorageOS as an application container for Docker Engine 1.10+ or
Kubernetes 1.7. [**Try it in your browser for up to one hour >>**](https://my.storageos.com/main/tutorial/install-with-docker)

## Prerequisites

It is recommended to use a stable version of [docker](https://docs.docker.com/release-notes/docker-ce/).

1. Get a [cluster discovery token]({%link _docs/install/prerequisites/clusterdiscovery.md %})
    ```bash
    $ storageos cluster create
    017e4605-3c3a-434d-b4b1-dfe514a9cd0f
    ```

1. [Enable LIO](/docs/reference/os_support) on each node.

## Install

Run StorageOS on each node, replacing `ADVERTISE_IP` with the host
ip address and `JOIN` with your token:

```bash
docker run -d --name storageos \
    -e HOSTNAME \
    -e ADVERTISE_IP=10.26.2.5 \
    -e JOIN=017e4605-3c3a-434d-b4b1-dfe514a9cd0f \
    --pid=host \
    --network=host \
    --privileged \
    --cap-add SYS_ADMIN \
    --device /dev/fuse \
    -v /sys:/sys \
    -v /var/lib/storageos:/var/lib/storageos:rshared \
    -v /run/docker/plugins:/run/docker/plugins \
    storageos/node:1.0.0-rc2 server
```

If you are performing a non-default installation, the following environment
variables can be provided:

* `HOSTNAME`: Hostname of the Docker node, only if you wish to override it.
* `ADVERTISE_IP`: IP address of the Docker node, for incoming connections.  Defaults to first non-loopback address.
* `USERNAME`: Username to authenticate to the API with.  Defaults to `storageos`.
* `PASSWORD`: Password to authenticate to the API with.  Defaults to `storageos`.
* `JOIN`: A URI defining the cluster for the node to join; see [cluster discovery]({% link _docs/install/prerequisites/clusterdiscovery.md %}).
* `DEVICE_DIR`: Where the volumes are exported.  This directory must be shared into the container using the rshared volume mount option. Defaults to `/var/lib/storageos/volumes`.
* `API_PORT`: Port for the API to listen on.  Defaults to `5705` ([IANA Registered](https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml?search=5705)).
* `NATS_PORT`: Port for NATS messaging to listen on.  Defaults to `5708`.
* `NATS_CLUSTER_PORT`: Port for the NATS cluster service to listen on.  Defaults to `5710`.
* `SERF_PORT`: Port for the Serf protocol to listen on.  Defaults to `5711`.
* `DFS_PORT`: Port for DirectFS to listen on.  Defaults to `5703`.
* `KV_PEER_PORT`: Port for the embedded Key/Value store. Defaults to `5707`.
* `KV_CLIENT_PORT`: Port for the embedded Key/Value store. Defaults to `5706`.
* `KV_ADDR`: IP address/port of an external Key/Vaue store.  Must be specified with `KV_BACKEND=etcd`.
* `KV_BACKEND`: Type of KV store to use. Defaults to `embedded`. `etcd` is supported with `KV_ADDR` set to an external etcd instance.
* `LOG_LEVEL`: One of `debug`, `info`, `warning` or `error`.  Defaults to `info`.
* `LOG_FORMAT`: Logging output format, one of `text` or `json`.  Defaults to `json`.
* `DISABLE_TELEMETRY`: To disable anonymous usage reporting across the cluster, set to `true`. Defaults to `false`. To help improve the product, data such as API usage and StorageOS configuration information is collected.
* `DISABLE_ERROR_REPORTING`: To disable error reporting across the cluster, set to `true`. Defaults to `false`. Errors are reported to help identify and resolve potential issues that may occur.

## Confirming installation

Load the [GUI]({%link _docs/reference/gui.md %}) on port 5705 on any of the nodes:

![Logging in](/images/docs/gui/login.png)

If this fails, [install the CLI]({%link _docs/reference/cli/index.md %}) and run
`storageos cluster health`. If any components are unhealthy, look at the Docker
logs:

```bash
$ docker logs storageos
time="2018-04-09T09:16:41Z" level=info msg="by using this product, you are agreeing to the terms of the StorageOS Ltd. End User Subscription Agreement (EUSA) found at: https://storageos.com/legal/#eusa" module=command
time="2018-04-09T09:16:41Z" level=info msg="starting server" address=172.17.0.7 cluster= hostname=host01 id=b80ac576-5bd0-4b0e-8b95-cbdea8233b08 join=7895d1a5-49ba-4b0a-82fd-5becd1b9c487 labels="map[]" module=command version="StorageOS 0.10.0 (d70f6f5), built: 2018-02-27T144558Z"
time="2018-04-09T09:16:41Z" level=info msg="starting api server" action=create category=server endpoint="0.0.0.0:5705" module=cp
time="2018-04-09T09:16:41Z" level=info msg="started temporary docker volume plugin api while control plane starts"
...
```

## Creating volumes

To use StorageOS volumes with containers, specify `--volume-driver storageos`:

```bash
$ docker container run -it --volume-driver storageos --volume myvol:/data busybox sh
/ #
```
This creates a new container with a StorageOS volume called `myvol` mounted at `/data`.

*Note: The [Docker managed plugin](https://hub.docker.com/r/storageos/plugin/) is deprecated.*

## Install systemd StorageOS service (optional)

1. Set the configuration file

    ```bash
   cat <<END > /etc/default/storageos

   # Advertise ip is the ip of the machine itself, where the service is being started
   ADVERTISE_IP="10.0.1.226"

   # Join variable set to all addresses of the cluster or a join token created from: storageos cluster create
   JOIN="10.0.1.14:5705,10.0.1.176:5705,10.0.1.226:5705"

   LOG_LEVEL=info
   END
    ```

    The `ADVERTISE_IP` will be used to expose ports, therefore it needs to be set to an address that the rest of instances in the cluster can connect. The `JOIN` variable 
    can be set according the [discovery method]({%link _docs/install/prerequisites/clusterdiscovery.md %}). In this case, it specifies every node of the StorageOS cluster. This
    variable can be set equally for all nodes that install systemd's service.

1. Create the storageos.service file

    ```bash
   cat <<END > /etc/systemd/system/storageos.service
   [Unit]
   Description=StorageOS
   Wants=network-online.target
   After=network-online.target
   After=docker.service
   Requires=docker.service

   [Service]
   TimeoutStartSec=0
   EnvironmentFile=/etc/default/storageos
   ExecStartPre=-/usr/bin/docker kill storageos
   ExecStartPre=-/usr/bin/docker rm storageos
   ExecStartPre=/usr/bin/docker pull storageos/node:1.0.0-rc2
   ExecStart=/usr/bin/docker run --name storageos -e DISABLE_TELEMETRY=true -e HOSTNAME -e ADVERTISE_IP -e JOIN --net=host --pid=host --privileged --cap-add SYS_ADMIN --device /dev/fuse -v /var/lib/storageos:/var/lib/storageos:rshared -v /run/docker/plugins:/run/docker/plugins -v /sys:/sys storageos/node:1.0.0-rc2 server
   ExecStop=/usr/bin/docker stop storageos

   [Install]
   WantedBy=default.target
   END
    ```

1. Start StorageOS

    ```bash
   systemctl daemon-reload
   systemctl start storageos.service

   # Check the logs
   systemctl status -l storageos.service
    ```

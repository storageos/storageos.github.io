# StorageOS Node Container

The StorageOS Node container turns your Docker node into a hyper-converged storage platform. Each Docker host that runs the Node container can contribute available local or attached storage into a distributed pool, which is then available to all cluster members via a global namespace.

_NOTE: For Docker 1.13+ most users should use the [managed plugin install](../plugin) method._

Volumes are available across the cluster so if a container gets moved to another node it still has access to its data. Data can be protected with synchronous replication. Compression, caching, and QoS are enabled by default, and all volumes are thin-provisioned.

No other hardware or software is required.

During beta, StorageOS is freely available for testing and experimentation. _DO NOT USE FOR PRODUCTION DATA_. A Developer edition will be free forever.

Full documentation is available at <https://docs.storageos.com>. To stay informed about new features and production-ready releases, sign up on our [customer portal](https://my.storageos.com).

## Quick Start

Provide the host ip address in ADVERTISE_IP and a cluster discovery token with JOIN when you install the container:

```bash
$ sudo mkdir /var/lib/storageos
$ sudo modprobe nbd nbds_max=1024
$ sudo curl -o /etc/docker/plugins/storageos.json --create-dirs https://docs.storageos.com/assets/storageos.json
$ docker run -d --name storageos \
    -e HOSTNAME \
    -e ADVERTISE_IP=xxx.xxx.xxx.xxx \
    -e JOIN=xxxxxxxxxxxxxxxxx \
    --net=host \
    --pid=host \
    --privileged \
    --cap-add SYS_ADMIN \
    --device /dev/fuse \
    -v /var/lib/storageos:/var/lib/storageos:rshared \
    -v /run/docker/plugins:/run/docker/plugins \
    storageos/node server
```

To provision a new `JOIN`, see [cluster discovery](http://docs.storageos.com/docs/install/prerequisites/clusterdiscovery).

## Use StorageOS

You can now run containers backed by StorageOS volumes:

```bash
sudo docker run -it --rm --volume-driver storageos -v test01:/data alpine sh -c "echo hello > /data/myfile"
```

Or pre-create and manage StorageOS volumes using the `docker volume` command:

```bash
sudo docker volume create --driver storageos --opt size=20 --opt storageos.feature.replicas=2 vol01
```

### Next Steps

To get the most out of StorageOS, try:

1. Running the CLI to manage volumes, rules, and cluster configuration. See <https://docs.storageos.com/docs/reference/cli.html>
1. Joining more nodes to the cluster. A quick start guide is available at <https://docs.storageos.com/docs/install/clusterinstall.html>
1. Fail containers to other nodes, or enable replication and fail Docker nodes.


## Requirements

### Docker Version

The container installation method requires Docker 1.10+. For Docker 1.13+ most users should use the [managed plugin install](../plugin) method.

## Installation

The node container (or plugin) should be installed on each Docker node where you want to consume StorageOS volumes or to present capacity to other nodes.

### State

StorageOS shares volumes via the `/var/lib/storageos` directory. This must be present on each node where StorageOS runs. Prior to installation, create it:

```bash
sudo mkdir /var/lib/storageos
```

### Network Block Device (NBD)

(Optional) NBD is a default Linux kernel module that allows block devices to be run in userspace. Enabling NBD is recommended as it will increase performance for some workloads. To enable the module and increase the number of allowable devices, you must either run:

```bash
sudo modprobe nbd nbds_max=1024
```

**To ensure the NBD module is loaded on reboot.**

1. Add the following line to `/etc/modules`

   ```bash
   nbd
   ```

2. Add the following module configuration line in `/etc/modprobe.d/nbd.conf`

   ```bash
   options nbd nbds_max=1024
   ```

### Docker Plugin Configuration

Docker needs to be configured to use the StorageOS volume plugin. This is done by writing a configuration file in `/etc/docker/plugins/storageos.json` with contents:

```json
{
    "Name": "storageos",
    "Addr": "unix:////run/docker/plugins/storageos/storageos.sock"
}
```

This file instructs Docker to use the volume plugin API listening on the specified Unix domain socket. Note that the socket is only accessible by the root user, and it is only present when the StorageOS client container is running.

### Run the StorageOS node container

Provide the host ip address in ADVERTISE_IP and a cluster discovery token with JOIN when you install the container:

```bash
$ docker run -d --name storageos \
    -e HOSTNAME \
    -e ADVERTISE_IP=xxx.xxx.xxx.xxx \
    -e JOIN=xxxxxxxxxxxxxxxxx \
    --net=host \
    --pid=host \
    --privileged \
    --cap-add SYS_ADMIN \
    --device /dev/fuse \
    -v /var/lib/storageos:/var/lib/storageos:rshared \
    -v /run/docker/plugins:/run/docker/plugins \
    storageos/node server
```

To generate a new cluster ID to use in `JOIN`, see [cluster discovery](http://docs.storageos.com/docs/install/prerequisites/clusterdiscovery).

Other configuration parameters (see Configuration Reference below) may be set in a similar way. For most environments, only the KV_ADDR will need to be set if Consul is not running locally on the node.

## Configuration Parameters

Although the default settings should work for most environments, a number of settings are configurable:

* `HOSTNAME`: Hostname of the Docker node, only if you wish to override it.
* `ADVERTISE_IP`: IP address of the Docker node, for incoming connections. Defaults to first non-loopback address.
* `USERNAME`: Username to authenticate to the API with. Defaults to `storageos`.
* `PASSWORD`: Password to authenticate to the API with. Defaults to `storageos`.
* `JOIN`: A URI defining the cluster for the node to join. Either in the form of a list of IPs, a cluster token (created through 'storageos cluster create') or both.
* `API_PORT`: Port for the API to listen on. Defaults to `5705` ([IANA Registered](https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml?search=5705)).
* `NATS_PORT`: Port for NATS messaging to listen on. Defaults to `4222`.
* `NATS_CLUSTER_PORT`: Port for the NATS cluster service to listen on. Defaults to `8222`.
* `SERF_PORT`: Port for the Serf protocol to listen on. Defaults to `13700`.
* `DFS_PORT`: Port for DirectFS to listen on. Defaults to `17100`.
* `KV_ADDR`: IP address/port of an external Key/Vaue store.  Must be specified with `KV_BACKEND=etcd`.
* `KV_BACKEND`: Type of KV store to use. Defaults to `embedded`. `etcd` is supported with `KV_ADDR` set to an external etcd instance, or `boltdb` can be used for single node testing.
* `LOG_LEVEL`: One of `debug`, `info`, `warning` or `error`. Defaults to `info`.
* `LOG_FORMAT`: Logging output format, one of `text` or `json`. Defaults to `json`.
* `DISABLE_TELEMETRY`: To disable anonymous usage reporting across the cluster, set to `true`. Defaults to `false`. To help improve the product, data such as API usage and StorageOS configuration information is collected.

# StorageOS Node Container

The StorageOS node container turns your Docker host into a hyper-converged storage platform. Each node that runs the StorageOS node container can contribute available local or attached storage into a distributed pool, which is then available to all cluster members via a global namespace.

Volumes are available across the cluster so if a container gets moved to another node it still has access to its data. Data can be protected with synchronous replication. Compression, caching, and QoS are enabled by default, and all volumes are thin-provisioned.

No other hardware or software is required, except an optional KV store.

For Docker 1.13+, a managed plugin is also available.

During beta, StorageOS is freely available for testing and experimentation. _DO NOT USE FOR PRODUCTION DATA_. A Developer edition will be free forever.

Full documentation is available at <https://docs.storageos.com>.

## Quick Start

```bash
$ sudo mkdir /var/lib/storageos
$ sudo modprobe nbd nbds_max=1024
$ wget -O /etc/docker/plugins/storageos.json http://docs.storageos.com/assets/storageos.json
$ docker run -d --name storageos \
    -e HOSTNAME \
    --net=host \
    --pid=host \
    --privileged \
    --cap-add SYS_ADMIN \
    --device /dev/fuse \
    -v /var/lib/storageos:/var/lib/storageos:rshared \
    -v /run/docker/plugins:/run/docker/plugins \
    store/storageos/node:0.7.5 server
```

That's it - you can now start containers with StorageOS-backed volumes:

```bash
$ docker run --name postgres01 \
    -e PGDATA=/var/lib/postgresql/data/db \
    -v postgres01:/var/lib/postgresql/data \
    --volume-driver=storageos -d postgres
```

Or pre-create and manage StorageOS volumes using the `docker volume` command:

```bash
$ docker volume create --driver storageos --opt size=20 --opt storageos.feature.replicas=2 vol01
```

### Next Steps

To get the most out of StorageOS, try:

1. Running the CLI to manage volumes, rules, and cluster configuration
2. Joining more nodes to the cluster

## Requirements

### Docker Version

The container installation method requires Docker 1.10+. For Docker 1.13+ most users should use the [managed plugin install](../plugin) method.

### Key-value Store

StorageOS relies on an external key-value store for configuration data and cluster management. Consul is required, though support for etcd is being tested and should be available in the future.

We believe that the KV store is best managed separately from the StorageOS plugin so that the plugin can remain stateless. Most organizations will already be familiar with managing Consul or etcd as they are common components in cloud-native architectures. For single-node testing, BoltDB is embedded and can be used in place of an external KV store.

For help setting up Consul, consult the [documentation](https://hub.docker.com/_/consul/).

## Installation

The node container (or plugin) should be installed on each Docker node where you want to consume StorageOS volumes or to present capacity to other nodes.

### State

StorageOS shares volumes via the `/var/lib/storageos` directory. This must be present on each node where StorageOS runs. Prior to installation, create it:

```bash
$ sudo mkdir /var/lib/storageos
```

### Network Block Device (NBD)

(Optional) NBD is a default Linux kernel module that allows block devices to be run in userspace. Enabling NBD is recommended as it will increase performance for some workloads. To enable the module and increase the number of allowable devices, you must either run:

```bash
$ sudo modprobe nbd nbds_max=1024
```

**To ensure the NBD module is loaded on reboot.**

1. Add the following line to `/etc/modules`
```
nbd
```

1. Add the following module configuration line in `/etc/modprobe.d/nbd.conf`
```
options nbd nbds_max=1024
```

### Docker Volume Driver Configuration

Docker needs to be configured to use the StorageOS volume plugin. This is done by writing a configuration file in `/etc/docker/plugins/storageos.json` with contents:

```json
{
    "Name": "storageos",
    "Addr": "unix:////run/docker/plugins/storageos/storageos.sock"
}
```

This file instructs Docker to use the volume driver API listening on the specified Unix domain socket. Note that the socket is only accessible by the root user, and it is only present when the StorageOS node container is running.

### Run the StorageOS node container

Run the node container, supplying the IP address of the Consul service using the `KV_ADDR` environment variable:

```bash
$ docker run -d --name storageos \
    -e HOSTNAME \
    -e KV_ADDR=127.0.0.1:8500 \
    --net=host \
    --pid=host \
    --privileged \
    --cap-add SYS_ADMIN \
    --device /dev/fuse \
    -v /var/lib/storageos:/var/lib/storageos:rshared \
    -v /run/docker/plugins:/run/docker/plugins \
    store/storageos/node:0.7.5 server
```

Alternatively, to setup a single test StorageOS instance, you can use the built-in BoltDB by setting `-e KV_BACKEND=boltdb`. Note that each StorageOS node will be isolated, so features such as replication and volume failover will not be available.

Other configuration parameters (see Configuration Reference below) may be set in a similar way. For most environments, only the `KV_ADDR` will need to be set if Consul is not running locally on the node.

## Configuration Parameters

Although the default settings should work for most environments, a number of settings are configurable:

- `HOSTNAME`: Hostname of the Docker node, only if you wish to override it.
- `KV_ADDR`: IP address/port of the Key/Vaue store. Defaults to `127.0.0.1:8500`
- `ADVERTISE_IP`: IP address of the Docker node, for incoming connections. Defaults to first non-loopback address.
- `USERNAME`: Username to authenticate to the API with. Defaults to `storageos`.
- `PASSWORD`: Password to authenticate to the API with. Defaults to `storageos`.
- `KV_ADDR`: IP address/port of the Key/Vaue store. Defaults to `127.0.0.1:8500`
- `KV_BACKEND`: Type of KV store to use. Defaults to `consul`. `boltdb` can be used for single node testing.
- `API_PORT`: Port for the API to listen on. Defaults to `5705` ([IANA Registered](https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml?search=5705)).
- `NATS_PORT`: Port for NATS messaging to listen on. Defaults to `4222`.
- `NATS_CLUSTER_PORT`: Port for the NATS cluster service to listen on. Defaults to `8222`.
- `SERF_PORT`: Port for the Serf protocol to listen on. Defaults to `13700`.
- `DFS_PORT`: Port for DirectFS to listen on. Defaults to `17100`.
- `LOG_LEVEL`: One of `debug`, `info`, `warning` or `error`. Defaults to `info`.
- `LOG_FORMAT`: Logging output format, one of `text` or `json`. Defaults to `json`.

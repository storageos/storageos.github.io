# StorageOS Volume Plugin

The StorageOS volume plugin turns your Docker node into a hyper-converged storage platform. Each node that runs the StorageOS plugin can contribute available local or attached storage into a distributed pool, which is then available to all cluster members via a global namespace.

Volumes are available across the cluster so if a container gets moved to another node it still has access to its data. Data can be protected with synchronous replication. Compression, caching, and QoS are enabled by default, and all volumes are thin-provisioned.

No other hardware or software is required.

For Docker 1.10 - 1.12, an application container is available (storageos-node).

During beta, StorageOS is freely available for testing and experimentation. _DO NOT USE FOR PRODUCTION DATA_. A Developer edition will be free forever.

Full documentation is available at <https://docs.storageos.com>. To stay informed about new features and production-ready releases, sign up on our [customer portal](https://my.storageos.com).

## Installation

_Optional:_ Enabling NBD prior to installation is recommended as it will increase performance for some workloads. To enable the module and increase the number of allowable devices run:

```bash
sudo modprobe nbd nbds_max=1024
```

**To ensure the NBD module is loaded on reboot.**

1. Add the following line to `/etc/modules`

```bash
$ nbd
```

1. Add the following module configuration line in `/etc/modprobe.d/nbd.conf`

```bash
$ options nbd nbds_max=1024
```

Provide the host ip address in `ADVERTISE_IP` and a cluster discovery token with `JOIN` when you install the plugin:

```bash
$ JOIN=$(storageos cluster create)
$ docker plugin install --alias storageos store/storageos/plugin:0.10.0 ADVERTISE_IP=$ADVERTISE_IP JOIN=$JOIN
```

For more details consult <https://docs.storageos.com/docs/install/docker.html>

## Use StorageOS

You can now run containers backed by StorageOS volumes:

```bash
sudo docker run -it --rm --volume-driver storageos -v test01:/data alpine sh -c "echo hello > /data/myfile"
```

Or pre-create and manage StorageOS volumes using the `docker volume` command:

```bash
sudo docker volume create --driver storageos --opt size=20 --opt storageos.com/replicas=2 vol01
```

## Next Steps

To get the most out of StorageOS, try:

1. Running the CLI to manage volumes, rules, and cluster configuration. See <https://docs.storageos.com/docs/reference/cli.html>
1. Joining more nodes to the cluster. A quick start guide is available at <https://docs.storageos.com/docs/install/clusterinstall.html>
1. Fail containers to other nodes, or enable replication and fail Docker nodes.

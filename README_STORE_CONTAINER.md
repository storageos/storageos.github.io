# StorageOS Node Container

The StorageOS node container turns your Docker host into a hyper-converged storage platform. Each node that runs the StorageOS node container can contribute available local or attached storage into a distributed pool, which is then available to all cluster members via a global namespace.

Volumes are available across the cluster so if a container gets moved to another node it still has access to its data. Data can be protected with synchronous replication. Compression, caching, and QoS are enabled by default, and all volumes are thin-provisioned.

No other hardware or software is required, except an optional KV store.

For Docker 1.13+, a managed plugin is also available.

During beta, StorageOS is freely available for testing and experimentation. _DO NOT USE FOR PRODUCTION DATA_. A Developer edition will be free forever.

Full documentation is available at <https://docs.storageos.com>.

## Installation

_Optional:_ Enabling NBD prior to installation is recommended as it will increase performance for some workloads. To enable the module and increase the number of allowable devices, you must either run:

```bash
$ sudo modprobe nbd nbds_max=1024
```

Install StorageOS:

```bash
$ sudo mkdir /var/lib/storageos
$ sudo modprobe nbd nbds_max=1024
$ sudo wget -O /etc/docker/plugins/storageos.json http://docs.storageos.com/assets/storageos.json
$ docker run -d --name storageos \
    -e HOSTNAME \
    --net=host \
    --pid=host \
    --privileged \
    --cap-add SYS_ADMIN \
    --device /dev/fuse \
    -v /var/lib/storageos:/var/lib/storageos:rshared \
    -v /run/docker/plugins:/run/docker/plugins \
    store/storageos/node server
```

This requires you to have Consul installed and available on the Docker host. You may specify a remote consul service by including `-e KV_ADDR=<consul_ip:8500>`. For single-node installs, you may specify `-e KV_BACKEND=boltdb` instead.

For more details consult <https://docs.storageos.com/docs/install/container.html>

## Use StorageOS

You can now run containers backed by StorageOS volumes:

```
$ sudo docker run -it --rm --volume-driver storageos -v test01:/data alpine sh -c "echo hello > /data/myfile"
```

Or pre-create and manage StorageOS volumes using the `docker volume` command:

```bash
$ sudo docker volume create --driver storageos --opt size=20 --opt storageos.feature.replicas=2 vol01
```

## Next Steps

To get the most out of StorageOS, try:

1. Running the CLI to manage volumes, rules, and cluster configuration. See <https://docs.storageos.com/docs/reference/cli.html>
2. Joining more nodes to the cluster. A quick start guide is available at <https://docs.storageos.com/docs/install/clusterinstall.html>
3. Fail containers to other nodes, or enable replication and fail Docker nodes.

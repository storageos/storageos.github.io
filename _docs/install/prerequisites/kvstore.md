---
layout: guide
title: StorageOS Docs - Key/Value Store
anchor: install
module: install/prerequisites/kvstore
---

# Key/Value Store

StorageOS requires a Key/Value store to persist cluster configuration and for
distributed locking. The KV store needs to be installed and ready before
StorageOS starts, otherwise it will wait for the KV store to be ready.

## Consul

Consul is an open source KV store from HashiCorp and the default KV store for
StorageOS. Starting StorageOS without `KV_BACKEND` or `KV_ADDR` set will assume
Consul is running locally at `127.0.0.1:8500`.

To get a Consul service up and running quickly for testing use the
[Consul image](https://hub.docker.com/_/consul/) from the Docker Hub. You will
need to start the Consul container on any three (or `num_nodes`) nodes in the
cluster.

```bash
docker run -d --name consul --net=host consul agent -server \
    -bind=${ip} \
    -client=0.0.0.0 \
    -bootstrap-expect=${num_nodes} \
    -retry-join=${leader_ip}
```

* `ip`: the public ip address of the Docker node
* `num_nodes`: how many nodes to run (3 is recommended for testing)
* `leader_ip`: one of the node's public ip addresses to act as the initial leader

Consult the [Consul documentation](https://www.consul.io) for detailed
installation and best practices.

For teams running their own Consul service, supply the host IP address for
`ADVERTISE_IP` together with `KV_ADDR` and port for the KV store (default port
is 8500).

```bash
sudo docker plugin install --grant-all-permissions --alias storageos storageos/plugin ADVERTISE_IP=<ip> KV_ADDR=<ip>:<port>
```

## Other

StorageOS will be adding support for other KV stores such as etcd and/or
zookeeper in future releases.

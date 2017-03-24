---
layout: guide
title: Consul
anchor: install
module: install/consul
---

# Consul Key/Value Store

StorageOS requires access to a Key/Value store to persist cluster configuration
and for distributed locking.

The ip address and port number of the consul service can be supplied to
StorageOS using the `KV_ADDR` parameter, with value `<ip>:<port>`.

Consult the [Consul documentation](https://www.consul.io) for detailed
installation and best practices.

## Quick Start

To get a Consul service up and running quickly for testing use the
[Consul image](https://hub.docker.com/_/consul/) from the Docker Hub.

You will need to specify:
* `ip`: the public ip address of the Docker node
* `num_nodes`: how many nodes to run (3 is recommended for testing)
* `leader_ip`: one of the node's public ip addresses to act as the initial leader

Start the Consul container on each node where Consul should run:

```bash
$ docker run -d --name consul --net=host consul agent -server \
-bind=${ip} \
-client=0.0.0.0 \
-bootstrap-expect=${num_nodes} \
-retry-join=${leader_ip}
```

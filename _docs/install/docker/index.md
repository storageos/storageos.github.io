---
layout: guide
title: StorageOS Docs - Docker only
anchor: install
module: install/docker/index
---

# Overview

StorageOS can be installed in two ways.

1. Kubernetes and Docker 1.10 - 1.13 users should use the [container install]({%
link _docs/install/docker/plugin.md %}).

2. All other users (eg. Docker Swarm, testing) should use the [volume plugin]({%
link _docs/install/docker/plugin.md %}).

With either approach, you will need to install StorageOS on every node in a
cluster.

Ensure you read [the prerequisites]({% link _docs/install/prerequisites/index.md %})
before installing StorageOS.

## Environment variables

For most environments, the default settings should work. If Consul is not
running locally on the node, you will need to set `KV_ADDR`.

* `HOSTNAME`: Hostname of the Docker node, only if you wish to override it.
* `ADVERTISE_IP`: IP address of the Docker node, for incoming connections.  Defaults to first non-loopback address.
* `USERNAME`: Username to authenticate to the API with.  Defaults to `storageos`.
* `PASSWORD`: Password to authenticate to the API with.  Defaults to `storageos`.
* `KV_ADDR`: IP address/port of the Key/Vaue store.  Defaults to `127.0.0.1:8500`
* `KV_BACKEND`: Type of KV store to use.  Defaults to `consul`. `boltdb` can be used for single node testing.
* `API_PORT`: Port for the API to listen on.  Defaults to `5705` ([IANA Registered](https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml?search=5705)).
* `NATS_PORT`: Port for NATS messaging to listen on.  Defaults to `4222`.
* `NATS_CLUSTER_PORT`: Port for the NATS cluster service to listen on.  Defaults to `8222`.
* `SERF_PORT`: Port for the Serf protocol to listen on.  Defaults to `13700`.
* `DFS_PORT`: Port for DirectFS to listen on.  Defaults to `17100`.
* `LOG_LEVEL`: One of `debug`, `info`, `warning` or `error`.  Defaults to `info`.
* `LOG_FORMAT`: Logging output format, one of `text` or `json`.  Defaults to `json`.

---
layout: guide
title: StorageOS Docs - Docker only
anchor: install
module: install/docker/index
---

# Overview

StorageOS can be installed in one of two ways.

1. For Kubernetes and Docker 1.10+, use the [container install]({%
link _docs/install/docker/container.md %}).

2. For Docker 1.13+ testing, use the [volume plugin]({%
link _docs/install/docker/plugin.md %}).

>**Do not install both the node and the plugin**. The plugin is harder to debug, so if in doubt, use the container install.

With either approach, you will need to install StorageOS on every node in a
cluster.

Ensure [the prerequisites]({% link _docs/install/prerequisites/index.md %}) are
fulfilled before installing StorageOS.

## Environment variables

For most environments, the default settings should work.

* `HOSTNAME`: Hostname of the Docker node, only if you wish to override it.
* `ADVERTISE_IP`: IP address of the Docker node, for incoming connections.  Defaults to first non-loopback address.
* `USERNAME`: Username to authenticate to the API with.  Defaults to `storageos`.
* `PASSWORD`: Password to authenticate to the API with.  Defaults to `storageos`.
* `CLUSTER_ID`: Cluster ID for the node to join an existing cluster previously created through 'storageos cluster create' command
* `INITIAL_CLUSTER`: Static list of pre-existing cluster, supplied as comma separated list of <hostname>=<url>:2380
* `API_PORT`: Port for the API to listen on.  Defaults to `5705` ([IANA Registered](https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml?search=5705)).
* `NATS_PORT`: Port for NATS messaging to listen on.  Defaults to `4222`.
* `NATS_CLUSTER_PORT`: Port for the NATS cluster service to listen on.  Defaults to `8222`.
* `SERF_PORT`: Port for the Serf protocol to listen on.  Defaults to `13700`.
* `DFS_PORT`: Port for DirectFS to listen on.  Defaults to `17100`.
* `LOG_LEVEL`: One of `debug`, `info`, `warning` or `error`.  Defaults to `info`.
* `LOG_FORMAT`: Logging output format, one of `text` or `json`.  Defaults to `json`.
* `DISABLE_TELEMETRY`: To disable anonymous usage reporting across the cluster, set to `true`. Defaults to `false`. To help improve the product, data such as API usage and StorageOS configuration information is collected.

---
layout: guide
title: StorageOS Docs - Configuration
anchor: reference
module: reference/configuration
---

# Configuration Reference

## Docker Plugin / Container

The default settings should work for most environments, though a number of
settings are configurable:

* `HOSTNAME`: Hostname of the Docker node, only if you wish to override it.
* `KV_ADDR`: IP address/port of the Key/Vaue store.  Defaults to `127.0.0.1:8500`
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

## Command Line Interface (CLI)

The CLI supports the following environment variables.  Any flags set in the
command line override their corresponding environment variables.

* `STORAGEOS_USERNAME`: Username for API authentication, equivalent of -u.
* `STORAGEOS_PASSWORD`: Password for API authentication, equivalent of -p.
* `STORAGEOS_HOST`: ip_address:port to connect to, equivalent of -H.

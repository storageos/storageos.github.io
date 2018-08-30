Configuration settings are available via environment variables:

* `HOSTNAME`: Hostname of the Docker node, only if you wish to override it.
* `ADVERTISE_IP`: IP address of the Docker node, for incoming connections.  Defaults to first non-loopback address.
* `USERNAME`: Username to authenticate to the API with.  Defaults to `storageos`.
* `PASSWORD`: Password to authenticate to the API with.  Defaults to `storageos`.
* `JOIN`: A URI defining the cluster for the node to join; see [cluster discovery]({% link _docs/prerequisites/clusterdiscovery.md %}).
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

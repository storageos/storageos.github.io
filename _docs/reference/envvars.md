---
layout: guide
title: StorageOS Docs - Environment Variables
anchor: reference
module: reference/envvars
---

# Environment Variables

Several aspects of StorageOS behaviour can be controlled via environment
variables. These can be injected in via any of the usual mechanisms such as
[ConfigMaps](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/).

* `JOIN`: *Required* A join token and/or list of cluster nodes to join.  The
  first node will bootstrap the cluster.  See [cluster discovery]({% link
_docs/prerequisites/clusterdiscovery.md %}).  There is no default; this must be
set for multiple-node clusters
* `HOSTNAME`: Hostname of the node, only if you wish to override it.  In
  Kubernetes environments, typically set to `spec.nodeName`
* `ADVERTISE_IP`: IP address of the node for incoming connections.  Defaults to
  first non-loopback address
* `DESCRIPTION`: The node description for display purposes only.  Default is
  unset
* `LABELS`: Comma separated list of node labels.  e.g.
  `LABELS=country=us,env=prod`.  Default is unset
* `USERNAME`: Username to authenticate to the API with.  Defaults to
  `storageos`
* `PASSWORD`: Password to authenticate to the API with.  Defaults to
  `storageos`
* `DEVICE_DIR`: Where the volumes are exported.  This directory must be shared
  into the container using the rshared volume mount option. Defaults to
`/var/lib/storageos/volumes`
* `API_PORT`: Port for the API to listen on.  Defaults to `5705` ([IANA
  Registered](https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml?search=5705))
* `NATS_PORT`: Port for NATS messaging to listen on.  Defaults to `5708`
* `NATS_HTTP_PORT`: Port for the NATS HTTP server to listen on.  Defaults to
  `5709`
* `NATS_CLUSTER_PORT`: Port for the NATS cluster service to listen on.
  Defaults to `5710`
* `SERF_PORT`: Port for the Serf protocol to listen on.  Defaults to `5711`
* `DFS_PORT`: Port for DirectFS to listen on.  Defaults to `5703`
* `KV_PEER_PORT`: Port for the embedded Key/Value store. Defaults to `5707`
* `KV_CLIENT_PORT`: Port for the embedded Key/Value store. Defaults to `5706`
* `KV_BACKEND`: Type of KV store to use. Defaults to `embedded`. `etcd` is
  supported with `KV_ADDR` set to an external etcd instance
* `KV_ADDR`: Comma separated list of etcd targets, in the form ip[:port].  Must
  be specified with `KV_BACKEND=etcd`.  Prefer multiple direct endpoints over a
single load-balanced endpoint
* `LOG_LEVEL`: One of `debug`, `info`, `warning` or `error`.  Defaults to
  `info`
* `LOG_FORMAT`: Logging output format, one of `text` or `json`.  Defaults to
  `json`
* `LOG_FILTER`: Used to discard log messages based on category.  e.g.
  `LOG_FILTER=cp=info,dp=info,etcd=debug`.  Default is unset
* `DISABLE_TELEMETRY`: To disable anonymous usage reporting across the cluster,
  set to `true`. Defaults to `false`. To help improve the product, data such as
API usage and StorageOS configuration information is collected
* `DISABLE_ERROR_REPORTING`: To disable error reporting across the cluster, set
  to `true`. Defaults to `false`. Errors are reported to help identify and
resolve potential issues that may occur
* `IN_K8S_CLUSTER`: Toggles enhanced Kubernetes integration.  Defaults to
  `true` and will be disabled automatically if Kubernetes API is not
accessible.  Requires StorageOS to be deployed as a DaemonSet or Pod.
* `KUBECONFIG`: Path to local kubeconfig file.  Not normally required.  Default
  is unset
* `NAMESPACE`: The orchestrator namespace that StorageOS is running in.  Used
  as the location to store encryption keys in.  Defaults to `storageos`
* `CSI_ENDPOINT`: If set, CSI compatibility is enabled.  Typically set to
  `unix://var/lib/kubelet/plugins_registry/storageos/csi.sock`.  Default is
unset
* `CSI_VERSION`: Added in `1.1.0` to define what version of CSI to use. Can be
  set to `v0` or `v1`, defaults to `v0`
* `PROBE_INTERVAL`: the interval between node probes. Takes a time duration in
  string format e.g. `500ms` or `2s`. Setting this lower (more frequent) will
  cause the cluster to detect failed nodes more quickly at the expense of
  increased bandwidth usage.  Defaults to 1000ms. Added in `1.1.2` replacing
  `PROBE_INTERVAL_MS`
* `PROBE_INTERVAL_MS`: the interval in milliseconds between node probes.
  Setting this lower (more frequent) will cause the cluster to detect failed
  nodes more quickly at the expense of increased bandwidth usage.  Defaults to
  1000ms. Added in `1.1.1` and deprecated in `1.1.2` See `PROBE_INTERVAL`
* `PROBE_TIMEOUT`: the timeout to wait for an ack from a probed node before
  assuming it is unhealthy.  Takes a time duration in string format e.g.
  `500ms` or `2s`. This should be set to 99-percentile of RTT (round-trip time)
  on your network.  Defaults to 3000ms. Added in `1.1.2` replacing
  `PROBE_TIMEOUT_MS`
* `PROBE_TIMEOUT_MS`: the timeout to wait for an ack from a probed node before
  assuming it is unhealthy.  This should be set to 99-percentile of RTT
  (round-trip time) on your network.  Defaults to 3000ms. Added in `1.1.1` and
  deprecated in `1.1.2` See `PROBE_TIMEOUT`

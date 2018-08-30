---
layout: guide
title: StorageOS Docs - Monitor volumes
anchor: operations
module: operations/monitor
---

# Monitor volumes

Prometheus stats are exported on each cluster node at
`http://ADVERTISE_IP:5705/metrics`. Prometheus 2.x is required.

```bash
$ curl -v http://localhost:5705/metrics
*   Trying ::1...
* Connected to localhost (::1) port 5705 (#0)
> GET /metrics HTTP/1.1
> Host: localhost:5705
> User-Agent: curl/7.47.0
> Accept: */*
>
< HTTP/1.1 200 OK
< Access-Control-Allow-Headers: Accept, Content-Type, Content-Length, Accept-Encoding,X-CSRF-Token, Authorization
< Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE
< Access-Control-Allow-Origin: *
< Date: Mon, 09 Apr 2018 12:55:50 GMT
< Content-Type: text/plain; charset=utf-8
< Transfer-Encoding: chunked
<
# HELP storageos_cluster_driver_count storageos_cluster_driver_count
# TYPE storageos_cluster_driver_count gauge
storageos_cluster_driver_count{instance="92745fc5-ecbb-f2f5-fa5d-b749b481ec8d",is_telemetry="true"} 1
# HELP storageos_cluster_pool_count storageos_cluster_pool_count
# TYPE storageos_cluster_pool_count gauge
storageos_cluster_pool_count{instance="92745fc5-ecbb-f2f5-fa5d-b749b481ec8d",is_telemetry="true"} 1
# HELP storageos_cluster_volume_degraded_count storageos_cluster_volume_degraded_count
# TYPE storageos_cluster_volume_degraded_count gauge
storageos_cluster_volume_degraded_count{instance="92745fc5-ecbb-f2f5-fa5d-b749b481ec8d",is_telemetry="true"} 0
# HELP storageos_cluster_volume_syncing_count storageos_cluster_volume_syncing_count
# TYPE storageos_cluster_volume_syncing_count gauge
storageos_cluster_volume_syncing_count{instance="92745fc5-ecbb-f2f5-fa5d-b749b481ec8d",is_telemetry="true"} 0
# HELP storageos_cluster_volume_suspect_count storageos_cluster_volume_suspect_count
# TYPE storageos_cluster_volume_suspect_count gauge
storageos_cluster_volume_suspect_count{instance="92745fc5-ecbb-f2f5-fa5d-b749b481ec8d",is_telemetry="true"} 0
# HELP storageos_cluster_device_count storageos_cluster_device_count
# TYPE storageos_cluster_device_count gauge
storageos_cluster_device_count{instance="92745fc5-ecbb-f2f5-fa5d-b749b481ec8d",is_telemetry="true"} 0
# HELP storageos_cluster_namespace_count storageos_cluster_namespace_count
# TYPE storageos_cluster_namespace_count gauge
storageos_cluster_namespace_count{instance="92745fc5-ecbb-f2f5-fa5d-b749b481ec8d",is_telemetry="true"} 1
# HELP storageos_cluster_node_count storageos_cluster_node_count
# TYPE storageos_cluster_node_count gauge
storageos_cluster_node_count{instance="92745fc5-ecbb-f2f5-fa5d-b749b481ec8d",is_telemetry="true"} 3
# HELP storageos_cluster_rule_count storageos_cluster_rule_count
# TYPE storageos_cluster_rule_count gauge
storageos_cluster_rule_count{instance="92745fc5-ecbb-f2f5-fa5d-b749b481ec8d",is_telemetry="true"} 0
# HELP storageos_cluster_volume_count storageos_cluster_volume_count
# TYPE storageos_cluster_volume_count gauge
storageos_cluster_volume_count{instance="92745fc5-ecbb-f2f5-fa5d-b749b481ec8d",is_telemetry="true"} 0
# HELP storageos_cluster_volume_dead_count storageos_cluster_volume_dead_count
# TYPE storageos_cluster_volume_dead_count gauge
storageos_cluster_volume_dead_count{instance="92745fc5-ecbb-f2f5-fa5d-b749b481ec8d",is_telemetry="true"} 0
# HELP storageos_cluster_volume_healthy_count storageos_cluster_volume_healthy_count
# TYPE storageos_cluster_volume_healthy_count gauge
storageos_cluster_volume_healthy_count{instance="92745fc5-ecbb-f2f5-fa5d-b749b481ec8d",is_telemetry="true"} 0
# HELP storageos_cluster_volume_total_size_gb storageos_cluster_volume_total_size_gb
# TYPE storageos_cluster_volume_total_size_gb gauge
storageos_cluster_volume_total_size_gb{instance="92745fc5-ecbb-f2f5-fa5d-b749b481ec8d",is_telemetry="true"} 0
# HELP exposer_request_latencies Latencies of serving scrape requests, in milliseconds
# TYPE exposer_request_latencies histogram
exposer_request_latencies_bucket{le="1"} 1
exposer_request_latencies_bucket{le="5"} 1
exposer_request_latencies_bucket{le="10"} 1
exposer_request_latencies_bucket{le="20"} 1
exposer_request_latencies_bucket{le="40"} 1
exposer_request_latencies_bucket{le="80"} 1
exposer_request_latencies_bucket{le="160"} 1
exposer_request_latencies_bucket{le="320"} 1
exposer_request_latencies_bucket{le="640"} 1
exposer_request_latencies_bucket{le="1280"} 1
exposer_request_latencies_bucket{le="2560"} 1
exposer_request_latencies_bucket{le="+Inf"} 1
exposer_request_latencies_sum 0
exposer_request_latencies_count 1
# HELP exposer_bytes_transferred bytesTransferred to metrics services
# TYPE exposer_bytes_transferred counter
exposer_bytes_transferred 1095
# HELP exposer_total_scrapes Number of times metrics were scraped
# TYPE exposer_total_scrapes counter
exposer_total_scrapes 1
* Connection #0 to host localhost left intact
```

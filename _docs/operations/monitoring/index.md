---
layout: guide
title: StorageOS Docs - Monitoring
anchor: operations
module: operations/monitoring
---

# Monitoring StorageOS

## Ingesting StorageOS Metrics

StorageOS metrics are exposed on each cluster node at
`http://ADVERTISE_IP:5705/metrics`. For a full list of metrics that the
endpoint provides please see [Prometheus Endpoint](/docs/reference/prometheus).
Metrics are exported in [Prometheus text
format](https://prometheus.io/docs/instrumenting/exposition_formats/#text-based-format),
so collectors such as
[Prometheus](https://prometheus.io),
[Telegraf](https://www.influxdata.com/time-series-platform/telegraf/) or
[Sensu](https://sensu.io/)
can be used. The examples on this page will reference Prometheus semantics.

For an example Prometheus and Grafana setup monitoring StorageOS please see the
example [here](/docs/operations/monitoring/prometheus-setup).

## Analysing Metrics

There are many metrics exposed by the Prometheus endpoint, but without a good
understanding of what each metric is measuring, they may be difficult to
interpret. To aid the visualisation of metrics a Grafana dashboard has been
made available [here](https://grafana.com/dashboards/10012).


## StorageOS Volume Metrics

### Measuring IOPS

One of the most popular ways to measure the efficacy of a device is to measure
the number of Input/Output Operations per Seconds (IOPS) the device can
achieve. `storageos_volume_frontend_write_total` and
`storageos_volume_frontend_read_total` can be used to calculate the IOPS rate
using builtin Prometheus functions.

The metrics themselves are counters that report the total read/write operations
for a volume from the application perspective. As a [counter can only
increase](https://prometheus.io/docs/concepts/metric_types/#counter) over time,
the prometheus `rate()` function needs to be applied to get a measure of
operations over time.
```bash
rate(storageos_volume_frontend_write_total[2m])
```
The Prometheus rate function calculates the per-second average rate of increase
for a counter, over the 2 minute time period given. So, the function above
gives the per-second average of writes over two minutes. Therefore, if the rate
of both read and write totals is taken they can be summed to give IOPS.

### Measuring Bandwidth

While IOPS is a measure of operations per second, bandwidth provides a
measure of throughput, usually in MB/s.
`storageos_volume_frontend_write_bytes_total` and
`storageos_volume_frontend_read_bytes_total` are exposed as a way to calculate
bandwidth from the application's perspective.

These metrics are counters that report the total bytes read from/written to a
volume. As with IOPS, a rate can be calculated to give the average number of
bytes per second.
```bash
rate(storageos_volume_frontend_write_bytes_total[2m])
```
As with IOPS, the function above gives the per-second average increase in bytes
written to a volume, therefore if the rate of read and write byte totals is
summed you have the total volume bandwidth.


### Frontend vs Backend Metrics

The StorageOS Prometheus endpoint exposes both frontend and backend volume
metrics. The frontend metrics relate to I/O operations against a StorageOS
volume's filesystem. These operations are those executed by applications
consuming StorageOS volumes. Backend metrics relate to I/O operations that the
StorageOS container runs against devices that store the [blob
files](/docs/concepts/volumes#blob-files). They are affected by StorageOS
features such as compression and encryption which the application is unaware
of.

## StorageOS Node Metrics

The metrics endpoint exposes a standard set of metrics for every process that
the StorageOS container starts, including the metrics below.

### Uptime

The StorageOS control plane is the first process that starts when a StorageOS
pod is created. The `storageos_control_process_start_time_seconds` is a gauge
that provides the start time of the control plane process since the Unix epoch.
```bash
time() - storageos_control_process_start_time_seconds{alias=~"$node"}
```
By subtracting the control plane start time from the current time since the
Unix epoch, the total uptime of the process can be derived.

### CPU Usage

The StorageOS container will spawn a number of different processes. To
calculate the total CPU footprint of the StorageOS container, these processes
need to be summed together. `*_cpu_seconds` metrics are counters that reflect
the total seconds of CPU time each process has used. 
```bash
(rate(storageos_control_process_cpu_seconds_total[3m]) +
rate(storastorageos_dataplane_process_cpu_seconds_total[3m]) +
rate(storastorageos_stats_process_cpu_seconds_total[3m])) * 100
```
To calculate the average number of seconds of CPU time used per second, a rate
must be taken. The rate expresses the fraction of 1 second of CPU time that was
used by the StorageOS process in one second. Therefore to express this as a
percentage, multiply by 100.

### Memory Usage

`*_resident_memory_bytes` metrics are gauges that show the current resident
memory of a StorageOS process. Although metrics about virtual memory usage are
also exposed, resident memory gives an overview of memory allocated to each
process that is actively being used.
```bash
storageos_control_process_resident_memory_bytes
storageos_director_process_resident_memory_bytes
storageos_stats_process_resident_memory_bytes
```
As with CPU usage the resident memory of each StorageOS process needs to be
summed to calculate the memory footprint of StorageOS processes. 

### Volumes per Node

StorageOS has two [volumes
types](https://docs.storageos.com/docs/concepts/replication); masters and
replicas. A master volume is the device that a pod mounts and the replicas are
hot stand-bys for the master volume. 
```bash
sum(storageos_node_volumes_total{alias=~"$node"}) by (alias, volume_type)
```
By summing across the Prometheus `alias` and
`volume_type` labels the number of master and replica volumes per node can be
found. Changes in the relative numbers of master and replicas indicate that volumes
have failed over, assuming that no new volumes or replicas have been created.



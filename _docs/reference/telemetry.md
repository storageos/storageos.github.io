---
layout: guide
title: StorageOS Telemetry
anchor: reference
module: reference/telemetry
---

# StorageOS Telemetry

StorageOS collects telemetry and error reports  from StorageOS clusters via two
different methods for two different purposes.

## Telemetry

* Telemetry is made up of the DNS query and crash reports sent to sentry.io once per day.
* Error reporting is the sentry.io crash dump reporting.

## sentry.io

StorageOS sends crash reports and information about the StorageOS cluster to
[sentry.io](https://sentry.io). This information helps our developers monitor
and fix crashes. Information is sent to sentry.io once per day or when a process inside the
StorageOS container crashes.

* The once per day report includes the cluster version, node counts and license information.
* The crash report contains the signal that triggered the shutdown (e.g. SIGSEGV),
the exit code and whether or not the crash generated a core dump.

All StorageOS clusters with a routable connection to the internet will send crash
reports to sentry.io over tcp/443. StorageOS respects environment variables that
[ProxyFromEnvironment](https://golang.org/pkg/net/http/#ProxyFromEnvironment)
uses.

An exhaustive list of information included in the once per day report is below:
* API version
* Cluster ID
* CPU architechture
* Go version
* Healthy volume count
* Logging level
* Logging user
* License type
* Namespace count
* Node count
* Pool count
* OS type
* Rule count
* Server name
* Sentry version
* StorageOS build information (CI pipeline reference)
* StorageOS version
* Suspect volume count
* Total volume size
* Volume count
* Volume degraded count
* Volume offline count
* Volume syncing count

An exhaustive list of information included in the crash report is below:
* API version
* Cluster ID
* CPU architechture
* Crashed component name
* Error level
* Error message
* Exceptions
* Exit code
* Datetime of crash
* Go version
* Kernel signal
* OS type
* License type
* Logging user
* Server name
* Stacktrace
* StorageOS build information (CI pipeline reference)
* StorageOS version
* Whether a core dump occured

## DNS Query

StorageOS will also send anonymized node ids, cluster id and StorageOS version
information to StorageOS using a DNS query. The information that we send in the
query is encoded as well as being anonymized. This query allows us to inform
Cluster admins when StorageOS upgrades are available in the StorageOS GUI and
in the logs.

The DNS query includes:
* Anonymized StorageOS Cluster ID
* Anonymized StorageOS node ID
* StorageOS version number

If `k8sDistro` is set then the Kubernetes version and Kubernetes distribution
will also be reported. This information helps us direct focus onto the most
relevant platforms.

## Disable Telemetry
It is possible to disable telemetry using the CLI, API, environment
variables or the StorageOS Cluster Spec.

#### API
The example below shows how you can use the /v1/telemetry API endpoint to disable or enable telemetry.

```bash
$ curl -X "PUT" "http://127.0.0.1:5705/v1/telemetry"        \
         -H 'Content-Type: application/json; charset=utf-8' \
         -u 'storageos:storageos'                           \
         -d $'{
             "telemetryEnabled": true,
             "reportErrors": false
         }'
```

#### StorageOS Cluster Spec
Disable telemetry explicitly through the configurable [spec parameters]({% link _docs/reference/cluster-operator/configuration.md %}) of the StorageOSCluster custom resource.

#### Environment Variables

You can use the following environmental variables to disable or enable telemetry.

```bash
DISABLE_TELEMETRY       # Disable the DNS query and once per day sentry.io reporting
DISABLE_ERROR_REPORTING # Disable sentry.io crash reports

```

You can find more information about StorageOS environment variables
[here]({%link _docs/reference/envvars.md %}).

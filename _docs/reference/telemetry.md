---
layout: guide
title: StorageOS Telemetry
anchor: reference
module: reference/telemetry
---

# StorageOS Telemetry

StorageOS collects telemetry and error reports  from StorageOS clusters via two
different methods for two different purposes.

## Sentry.io

StorageOS sends crash dumps and information about the StorageOS cluster to
[sentry.io](https://sentry.io). This information helps our developers monitor
and fix crashes.

Information is sent to Sentry.io once per day or when a process inside the
StorageOS container crashes. The once per day report includes the cluster version,
node counts and license information. The crash report contains
the crash dumps that were generated. 

All StorageOS clusters with a routable connection to the internet will send crash
dumps to Sentry over tcp/443. StorageOS respects environment variables that
[ProxyFromEnvironment](https://golang.org/pkg/net/http/#ProxyFromEnvironment)
uses.

## DNS Query

StorageOS will also send anonymized node ids, cluster id and StorageOS version
information to StorageOS using a DNS query. The information that we send in the
query is encrypted as well as being anonymized. This query allows us to inform
Cluster admins when StorageOS upgrades are available in the StorageOS GUI.

## Disabling Telemetry

It is possible to disable telemetry using the CLI, API or environment
variables.

* Telemetry is the DNS query and Sentry.io once per day reporting. 
* Error reporting is the Sentry.io crash dump reporting. 

## API

You can use the /v1/telemetry API endpoint to disable or enable telemetry. 

```bash
$ curl -X "PUT" "http://127.0.0.1:5705/v1/telemetry"        \
         -H 'Content-Type: application/json; charset=utf-8' \
         -u 'storageos:storageos'                           \
         -d $'{
             "telemetryEnabled": true,
             "reportErrors": false
         }'
```
The example above shows how you can disable and enable reporting. 

## Environment Variables

You can use the following environmental variables to disable or enable telemetry.

```bash
DISABLE_TELEMETRY       # Disable the DNS query and once per day Sentry.io
reporting
DISABLE_ERROR_REPORTING # Disable SentryIO crash dump reports
```

You can find more information about StorageOS environment variables
[here]({%link _docs/reference/envvars.md %}).

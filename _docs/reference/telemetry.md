---
layout: guide
title: StorageOS Telemetry
anchor: reference
module: reference/telemetry
---

# StorageOS Telemetry

StorageOS collects telemetry from StorageOS clusters via two different methods
for two different purposes.

## Sentry.io

StorageOS sends crash dumps and information about the StorageOS cluster to sentry.io.
This information helps our devleopers monitor and fix crashes. This information 
includes the cluster version, node counts and license information as well as
any crash dumps.

Information is sent to Sentry.io once per day or when a process inside the
StorageOS container crashes. All StorageOS clusters with a routable connection
to the internet will send crash dumps to Sentry using an HTTPS connection. 

## DNS Query

StorageOS will also send anonymized node ids, cluster id and StorageOS version
information to StorageOS using a DNS query. The information that we send in the
query is encrypted as well as being anonymized. This query allows us to inform
Cluster admins when StorageOS upgrades are avaliable in the StorageOS GUI.

## Disabling Telemetry

It is possible to disable telemetry using the CLI, API or environment
variables.

## API


## CLI


## Environment Variables

You can use the following environmental variables to disable telemetry. 

```bash
DISABLE_TELEMETRY       # Disable the DNS query
DISABLE_ERROR_REPORTING # Disable the SentryIO reporting
```

You can find more information about StorageOS environment variables
[here]({%link _docs/reference/envvars.md %})

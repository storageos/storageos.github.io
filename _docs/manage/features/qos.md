---
layout: guide
title: StorageOS Docs - QoS
anchor: manage
module: manage/features/qos
---

# Quality of service

You can deprioritize the traffic on noisy apps by throttling ie. reducing the rate of disk I/O.

## Create a throttled volume

To create a throttled volume, set the `storageos.feature.throttle` label:

```bash
storageos volume create --namespace default --label storageos.feature.throttle=true volume-name
```

or the Docker CLI:

```bash
$ docker volume create --driver storageos --opt size=15 --opt storageos.features.throttle=true volume-name
volume-name
```

---
layout: guide
title: StorageOS Docs - Caching
anchor: manage
module: manage/features/caching
---

# Caching

Local caching improves read performance by using memory to cache data.

## Create a cached volume

To create a cached volume, set the `storageos.feature.cache` label with the StorageOS CLI:

```bash
storageos volume create --namespace default --label storageos.feature.cache=true volume-name
```

or the Docker CLI:

```bash
$ docker volume create --driver storageos --opt size=15 --opt storageos.feature.cache=true volume-name
volume-name
```

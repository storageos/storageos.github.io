---
layout: guide
title: StorageOS Docs - Caching
anchor: manage
module: manage/features/caching
---

# Caching

Local caching improves read performance by using memory to cache data. By
default caching uses 5% of available memory and increases based on:
* More than 3GB total, 7%
* More than 8GB total, 13%
* More than 12 GB free, 20%.

## Create a cached volume

All reads and writes are cached by default. To disable caching (eg. during
database backups which do not need to be cached), set the
`storageos.feature.nocache` label:

```bash
storageos volume create --namespace default --label storageos.feature.nocache=true volume-name
```

or the Docker CLI:

```bash
$ docker volume create --driver storageos --opt size=15 --opt storageos.feature.nocache=true volume-name
volume-name
```

To cache reads but not writes, for example when doing backups, set `nowritecache`.

---
layout: guide
title: StorageOS Docs - Caching
anchor: manage
module: manage/features/caching
---

# Caching

Local caching improves read performance by using memory to cache data.

## Create a cached volume

All reads and writes are cached by default. To disable caching, set the
`storageos.feature.nocache` label with the StorageOS CLI:

```bash
storageos volume create --namespace default --label storageos.feature.nocache=true volume-name
```

or the Docker CLI:

```bash
$ docker volume create --driver storageos --opt size=15 --opt storageos.feature.nocache=true volume-name
volume-name
```

To cache reads but not writes, for example when doing backups, set `nowritecache`.

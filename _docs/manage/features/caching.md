---
layout: guide
title: StorageOS Docs - Caching
anchor: manage
module: manage/features/caching
---

# Caching

Local caching improves read performance by using memory to cache data.

| Available memory   | StorageOS cache size |
|:-------------------|:---------------------|
| 3 GB or less       | 3%                   |
| 3-8 GB             | 5%                   |
| 8-12 GB            | 7%                   |
| 12 GB or more      | 10%                  |

## Create a cached volume

All reads and writes are cached by default. To disable caching (e.g. during
database backups which do not need to be cached), set the
`storageos.com/nocache` label:

```bash
storageos volume create --label storageos.feature.nocache=true volume-name
```

or the Docker CLI:

```bash
$ docker volume create --driver storageos --opt size=15 --opt storageos.feature.nocache=true volume-name
volume-name
```

To cache reads but not writes, for example when doing backups, set `nowritecache`.

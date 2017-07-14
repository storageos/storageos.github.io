---
layout: guide
title: StorageOS Docs - Replication
anchor: manage
module: manage/features/replication
---

# Replication

## Create a replicated volume

To create a replicated volume, specify the number of desired replicas with the
`storageos.feature.replicas` label. See [labels]({% link _docs/manage/volumes/labels.md %})
for replication best practices.

To create a volume with 2 replicas (3 copies of the data total), run:

### StorageOS CLI

```bash
storageos volume create --namespace default --label storageos.feature.replicas=2 volume-name
```

### Docker CLI

```bash
$ docker volume create --driver storageos --opt size=15 --opt storageos.feature.replicas=2 volume-name
volume-name
```

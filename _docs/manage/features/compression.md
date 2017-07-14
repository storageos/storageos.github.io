---
layout: guide
title: StorageOS Docs - Compression
anchor: manage
module: manage/features/compression
---


# Compression

Compression reduces the amount of data stored or transmitted to reduce performance. Data in transit is always compressed to reduce network traffic, and data at rest is compressed by default but can be disabled.

## Create a uncompressed volume

All volumes are compressed by default. To create an uncompressed volume, set the `storageos.feature.nocompression` label with the StorageOS CLI:

```bash
storageos volume create --namespace default --label storageos.feature.nocompression=true volume-name
```

or the Docker CLI:

```bash
$ docker volume create --driver storageos --opt size=15 --opt storageos.feature.nocompression=true volume-name
volume-name
```

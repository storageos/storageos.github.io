---
layout: guide
title: StorageOS Docs - Docker container
anchor: docker
module: docker/provision-volumes
---

## Creating volumes

To use StorageOS volumes with containers, specify `--volume-driver storageos`:

```bash
$ docker container run -it --volume-driver storageos --volume myvol:/data busybox sh
/ #
```
This creates a new container with a StorageOS volume called `myvol` mounted at `/data`.

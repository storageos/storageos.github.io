---
layout: guide
title: StorageOS Docs - Docker container
anchor: platforms
module: platforms/docker/provision-volumes
---

# Create volumes

To use StorageOS volumes with containers, specify `--volume-driver storageos`:

```bash
$ docker container run -it --volume-driver storageos --volume myvol:/data busybox sh
/ #
```
This creates a new container with a StorageOS volume called `myvol` mounted at `/data`.

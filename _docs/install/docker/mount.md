---
layout: guide
title: StorageOS Docs - Docker only
anchor: install
module: install/docker/mount
---

# Mounting volumes to a container

Specify `--volume-driver storageos` when mounting StorageOS volumes to a container.

To mount `myvol` into a new container at `/data` and start an interactive
shell:

```bash
$ docker container run -it --volume-driver storageos --volume myvol:/data busybox sh
/ #
```

StorageOS creates `default/myvol` if it doesn't exist and mounts it inside the
container at `/data`:

```bash
/ # touch /data/testfile
/ # exit
```

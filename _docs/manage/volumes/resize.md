---
layout: guide
title: StorageOS Docs - Resizing volumes
anchor: manage
module: manage/volumes/resize
---

# Resizing volumes

To resize a volume, use `storageos volume update`.

```bash
$ storageos volume update --help

Usage:	storageos volume update [OPTIONS] VOLUME

Update a volume

Options:
  -d, --description string   Volume description
      --help                 Print usage
      --label-add list       Add or update a volume label (key=value) (default [])
      --label-rm list        Remove a volume label if exists (default [])
  -s, --size int             Volume size in GB (default 5)
```

The volume is expanded immediately but you still need to manually resize the
filesystem by calling resize2fs.

Shrinking a volume is not supported in the beta.

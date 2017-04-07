---
layout: guide
title: Create and manage volumes
anchor: manage
module: manage/volumes
---

# Volumes

Volumes are used to store data.

## Create a volume

To create a 15GB volume in `default` namespace, run:

    storageos volume create --namespace default --size 15 volume-name

## List all volumes

To view volumes, run:

    storageos volume ls

This command will print all volumes from all namespaces.

## Labels

Labels are a mechanism for applying metadata to StorageOS objects. You can use them to annotate or organise your volumes in any way that makes sense for your business or app.

A label is a key-value pair that is stored as a string. An object may have multiple labels but each key-value pair must be unique within an object.

You should prefix labels with your organisation domain, such as `example.your-label`. Labels prefixed with `storageos.*` are reserved for internal use.

Applying special labels triggers features:

* `storageos.driver=filesystem` - defaults to `filesystem` driver.
* `storageos.feature.replicas=2` - number of desired replicas (0-5).
* `storageos.feature.compression=true` - network compression, depending on data type might greatly increase throughput.
* `storageos.feature.throttle=true` - reduce volume's performance.
* `storageos.feature.cache=true` - enable caching for volume.

## Inspecting volume details

To view volume details, such as where it's deployed, labels and health, use `inspect` command and specify both namespace `default` and volume name `volume-name` separated by `/`:

    storageos volume inspect default/volume-name

## Removing volumes

To delete a volume, use `rm` command (all data in this volume will be lost):

    storageos volume rm default/volume-name

This command will fail if the volume is mounted, to delete mounted volume, add `--force` flag:

    storageos volume rm --force default/volume-name

Volumes might not immediately disappeared as data from the disks have to be purged.

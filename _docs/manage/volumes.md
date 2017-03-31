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

## Inspecting volume details

To view volume details, such as where it's deployed, labels and health, use `inspect` command and specify both namespace `default` and volume name `volume-name` separated by `/`:

    storageos volume inspect default/volume-name

## Removing volumes 

To delete a volume, use `rm` command (all data in this volume will be lost):

    storageos volume rm default/volume-name

This command will fail if the volume is mounted, to delete mounted volume, add `--force` flag:

    storageos volume rm --force default/volume-name     

Volumes might not immediately disappeared as data from the disks have to be purged.
---
layout: guide
title: StorageOS Docs - Node diagnostics
anchor: manage
module: manage/node
---

# Node

Node shows a per node breakdown of your storage cluster.

## Overview

## Listing node information

To view the state of your cluster simply run:
```bash
storageos node ls

NAME                  ADDRESS             HEALTH              SCHEDULER           VOLUMES             TOTAL               USED                VERSION             LABELS
vol-test-2gb-lon101   46.101.50.155       Healthy 2 days      true                M: 0, R: 2          77.43GiB            5.66%               0.7 (00ab7b3 rev)
vol-test-2gb-lon102   46.101.50.231       Healthy 2 days      false               M: 1, R: 0          38.71GiB            5.90%               0.7 (00ab7b3 rev)
vol-test-2gb-lon103   46.101.51.16        Healthy 2 days      false               M: 1, R: 1          77.43GiB            5.61%               0.7 (00ab7b3 rev)
```

From the output of the command we observe that we have a 3 node StorageOS cluster and the following information:
- IP addresses of the controller nodes
- The health of the cluster and uptime
- Whether the node is a scheduler node or not
- Number of master copies of volumes or replicas
- Total capacity in node
- Percentage of capacity that is in use
- The version of StorageOS installed


## Inspect a node:

For a more detailed overview of a node's status you can inspect it, 
for example, let's inspect node 3

```
storageos node inspect vol-test-2gb-lon103
[
    {
        "id": "2b59bf5b-53c7-89dd-35c3-0439af6870e0",	 
        "hostID": 18226,															
        "scheduler": false,														 
        "name": "vol-test-2gb-lon103",								
        "address": "46.101.51.16",
        "apiPort": 5705,
        "natsPort": 4222,
        "natsClusterPort": 8222,
        "serfPort": 13700,
        "dfsPort": 17100,
        "description": "",
        "controllerGroups": null,
        "tags": null,
        "labels": null,
        "volumeStats": {
            "masterVolumeCount": 1,
            "replicaVolumeCount": 1,
            "virtualVolumeCount": 0
        },
        "poolStats": {
            "default": {
                "filesystem": {
                    "totalCapacityBytes": 41567956992,
                    "availableCapacityBytes": 39235608576,
                    "provisionedCapacityBytes": 0
                }
            },
            "pool13": {
                "filesystem": {
                    "totalCapacityBytes": 41567956992,
                    "availableCapacityBytes": 39235608576,
                    "provisionedCapacityBytes": 0
                }
            }
        },
        "health": "healthy",
        "healthUpdatedAt": "2017-05-12T17:59:39.841776028Z",
        "versionInfo": {
            "storageos": {
                "name": "storageos",
                "buildDate": "2017-05-12T104014Z",
                "revision": "00ab7b3",
                "version": "0.7",
                "apiVersion": "1",
                "goVersion": "go1.7.3",
                "os": "linux",
                "arch": "amd64",
                "kernelVersion": "",
                "experimental": false
            }
        },
        "version": "StorageOS 0.7 (00ab7b3), Built: 2017-05-12T104014Z",
        "capacityStats": {
            "totalCapacityBytes": 83135913984,
            "availableCapacityBytes": 78471217152,
            "provisionedCapacityBytes": 0
        }
    }
]
```

As you can see more detailed information such as state, port configuration, pool
membership, health, version and capacity are printed in JSON format.

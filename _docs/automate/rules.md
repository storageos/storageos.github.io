---
layout: guide
title: StorageOS Docs - Rules
anchor: automate
module: automate/rules
---

# Rules

Rules apply custom configuration to volumes based on matched labels.

## Overview

Rules are used for managing data policy and placement using StorageOS features
such as replication, QoS and compression.

Rules are created using [labels and selectors]({% link _docs/manage/volumes/labels.md %})
to evaluate which StorageOS features to apply.

Rules are evaluated when a volume is created. If the selector is satisfied, the
labels are applied to the new volume.

## Required parameters

The minimum parameters to create a rule are `--selector` and `--label`.

Create a rule that configures 2 replicas for volumes with the label `env=prod`:

```bash
$ storageos rule create --namespace default --selector 'env==prod' --label storageos.feature.replicas=2 replicator
default/replicator
```

## Optional parameters

Rules also accept the optional parameters `--action` and `--weight`.

`-a, --action string        Rule action (add|remove) (default "add")`

Where multiple rules apply to the same label, a weight is used to determine the
order of evaluation. Rules are evaluated starting at the lowest weight.

`-w, --weight int           Rule weight determines processing order, any integer`



## Using rules

To create a rule that configures 2 replicas for volumes with the label env=prod:

```bash
$ storageos rule create --namespace default --selector 'env==prod' --action add --label storageos.feature.replicas=2 replicator
default/replicator
```

View rules:

```bash
$ storageos rule ls
NAMESPACE/NAME        SELECTOR                       ACTION              LABELS
default/dev-marker    !storageos.feature.replicas    add                 env=dev
default/prod-marker   storageos.feature.replicas>1   add                 env=prod
default/replicator    env==prod                      add                 storageos.feature.replicas=2
default/uat-marker    storageos.feature.replicas<2   add                 env=uat
```

Inspect a rule:

```
$ storageos rule inspect default/replicator
[
    {
        "id": "9db3252a-bd14-885b-0d0a-b0da1dd2d4a1",
        "name": "replicator",
        "namespace": "default",
        "description": "",
        "active": true,
        "weight": 5,
        "action": "add",
        "selector": "env==prod",
        "labels": {
            "storageos.feature.replicas": "2"
        }
    }
]
```

Then, create a volume:

    storageos volume create -n default -s 1 --label env=prod prodVolume

Once it's created, inspect it:


    storageos volume inspect default/prodvolume

You should see that it has two replicas provisioned and additional labels attached:

```json
"labels": {
        "env": "prod",
        "storageos.driver": "filesystem",
        "storageos.feature.replicas": "2"
    },
```

Delete a rule:

```bash
$ storageos rule rm default/replicator
default/replicator
```

### Using advanced selectors

Let's create several rules that instead of adding `storageos.feature.replicas`
feature label it would read it's value and based on it would label volumes with
`dev/uat/prod` env values.

First, create a rule to label `dev` environments:

```bash
storageos rule create --namespace default --selector '!storageos.feature.replicas' --action add --label env=dev dev-marker
```

This rule will be matching volumes that do not have (`!`) label `storageos.feature.replicas` and will add `env=dev`
label.  Now, create a second rule to select volumes that have 1 replica (`< 2`) and add `uat` env label to them:

```bash
storageos rule create --namespace default --selector 'storageos.feature.replicas<2' --action add --label env=uat uat-marker
```

Create new volume with 1 replica:

```bash
storageos volume create --namespace default --label storageos.feature.replicas=1 uat-volume
```

Inspect it:

```bash
storageos volume inspect default/uat-volume
```

Labels should look like:

```bash
"labels": {
    "env": "uat",
    "storageos.driver": "filesystem",
    "storageos.feature.replicas": "1"
},
```

Finally, create a rule that will mark volumes as `prod` if they have 2 or more
(`gt`) configured replicas:

```bash
storageos rule create --namespace default --selector 'storageos.feature.replicas>1' --label env=prod prod-marker
default/prod-marker
```

Volumes created with 2 or more replicas should get `env=prod` label.

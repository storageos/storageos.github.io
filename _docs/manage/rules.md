---
layout: guide
title: StorageOS Docs - Rules
anchor: manage
module: manage/rules
---

# Rules

Rules apply custom configuration to volumes based on matched labels.

## Overview

Rules are used for managing data policy and placement using StorageOS *features* such as replication, QoS and compression.

Rules are created using *labels* and *operators* to evaluate what StorageOS *feature* to apply.  Where multiple rules apply to the same label, a *weight* is used to determine the order of evaluation.

Rules are subsequently applied to volumes based on their matched labels.

```
$ storageos rule create --help

Usage:	storageos rule create [OPTIONS] [RULE]

Create a rule

Options:
  -a, --action string        Rule action (add|remove) (default "add")
      --active               Enable or disable the rule (default true)
  -d, --description string   Rule description
      --help                 Print usage
      --label list           Labels to apply when rule is triggered (default [])
  -n, --namespace string     Namespace
  -s, --selector string      Selector, i.e. 'tier != frontend' (default "")
  -w, --weight int           Rule weight determines processing order (0-10) (default 5)

```

## Parameters

To create a rule, a number of parameters need to be set from the command line.

### Actions

Available actions are `add` or `remove` (defaults to `add` for new rules).

`-a, --action string        Rule action (add|remove) (default "add")`

### Labels

Labels can be added to *volumes* at creation time or modified at any time.

Similarly, labels can be added to *rules* and modified at any time based on the *action* applied (see below for more information on *actions*).

Each object can have a set of key/value labels defined. Each Key must be unique for a given object.

```json
"labels": {
  "key1" : "value1",
  "key2" : "value2"
}
```

### Features

Feature labels are StorageOS features implemented in either the Control Plane or in the Data Plane.  Features are what rules enable to enforce data policy and placement.

| Feature     | Label                         | Value                       |
|:------------|:------------------------------|-----------------------------|
| Driver      | storageos.driver              | filesystem (default)        |
| Replication | storageos.feature.replicas    | integer values 1 - 5        |
| Compression | storageos.feature.compression | true / false                |
| QoS         | storageos.feature.throttle    | true / false                |
| Caching     | storageos.feature.cache       | true / false                |

### Selectors

Selector and volume labels can be evaluated using a number of supported operators.

| Operator | Type        | Meaning                                                    |
|:---------|:------------|------------------------------------------------------------|
| `==`     | Comparison  | equal to                                                   |
| `!=`     | Comparison  | not equal to                                               |
| `>`      | Relational  | numeric greater than                                       |
| `<`      | Relational  | numeric less than                                          |
| `in`     | Conditional | compare a value with a list of values it's in              |
| `notin`  | Conditional | compare a value with a list of values it's not in          |
| `exists` | Conditional | true as soon as a match is found - similar to in           |
| `!`      | Unary       | logical not - if the expression is true, false is returned |
| `=`      | Assignment  | assigns a value                                            |
|          |             |                                                            |


A selector is a string that defines conditions and is used to trigger a *rule* against a *volume*.
When a volume is created, each rule is evaluated in ascending weight order. Each matching selector triggers the effect of the rule.

For example a selector can be `env==prod` or `tier!=frontend`; essentially the cluster administrator determines what these can be as they are not built-in.

`-s, --selector string        key=value selectors to trigger rule (default [])`

### Weight

Rules are evaluated starting at the lowest weight.

`-w, --weight int           Rule weight determines processing order, any integer`


## Creating a rule

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

```
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

Let's create several rules that instead of adding `storageos.feature.replicas` feature label it would read it's value and based on it would label volumes with `dev/uat/prod` env values.

First, create a rule to label `dev` environments:

    storageos rule create --namespace default --selector '!storageos.feature.replicas' --action add --label env=dev dev-marker

This rule will be matching volumes that do not have (`!`) label `storageos.feature.replicas` and will add `env=dev` label.
Now, create a second rule to select volumes that have 1 replica (`< 2`) and add `uat` env label to them:

    storageos rule create --namespace default --selector 'storageos.feature.replicas<2' --action add --label env=uat uat-marker

Create new volume with 1 replica:

    storageos volume create -n default --label storageos.feature.replicas=1 uat-volume

Inspect it:

    storageos volume inspect default/uat-volume

Labels should look like:

```
"labels": {
    "env": "uat",
    "storageos.driver": "filesystem",
    "storageos.feature.replicas": "1"
},
```

Finally, create a rule that will mark volumes as `prod` if they have 2 or more (`gt`) configured replicas:

    storageos rule create --namespace default --selector 'storageos.feature.replicas>1' --action add --weight 10 --label env=prod prod-marker
default/prod-marker

Volumes, created with 2 or more replicas should get `env=prod` label.

To list all rules:

```
$ storageos rule ls
NAMESPACE/NAME        OPERATOR            SELECTOR                       ACTION              LABELS
default/dev-marker    notin               storageos.feature.replicas=1   add                 env=dev
default/prod-marker   gt                  storageos.feature.replicas=1   add                 env=prod
default/uat-marker    lt                  storageos.feature.replicas=2   add                 env=uat
```

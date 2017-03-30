---
layout: guide
title: Create and manage rules
anchor: manage
module: manage/rules
---

# Rules

Rules apply custom configuration to volumes based on matched labels.

Rule specific parameters:

* selector - selector is a list of labels that will be used to match against volumes. For example selector can be `env=prod`.
* operator - comparison operator (!|=|==|in|!=|notin|exists|gt|lt) (default "=="). Operators such as `gt` and `lt` assume that selector and volume label values of that key are digits.
* action - `add` or `remove` (defaults to `add` for new rules). 
* label - rule labels are either aded to matched volumes or removed (depends on action).
* weight - all rules are sorted on weight before executed. It can be used to prioritize some rules over others.


## Create a rule

To create a rule that configures 2 replicas for volumes with the label env=prod, run:

    storageos rule create --namespace default --selector env=prod --operator == --action add --label storageos.feature.replicas=2 replicator

To view rules, run:

    storageos rule ls

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

### Using advanced operators

Let's create several rules that instead of adding `storageos.feature.replicas` feature label it would read it's value and based on it would label volumes with `dev/uat/prod` env values.

First, create a rule to label `dev` environments:

    storageos rule create --namespace default --selector storageos.feature.replicas=1 --operator notin --action add --label env=dev dev-marker

This rule will be matching volumes that do not have (`notin`) label `storageos.feature.replicas` and will add `env=dev` label.
Now, create second rule to select volumes that have 1 replica and add `uat` env label to them:

    storageos rule create --namespace default --selector storageos.feature.replicas=2 --operator lt --action add --label env=uat uat-marker

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

    storageos rule create --namespace default --selector storageos.feature.replicas=1 --operator gt --action add --weight 10 --label env=prod prod-marker

Volumes, created with 2 or more replicas should get `env=prod` label.

To list all rules:

```
$ storageos rule ls
NAMESPACE/NAME        OPERATOR            SELECTOR                       ACTION              LABELS
default/dev-marker    notin               storageos.feature.replicas=1   add                 env=dev
default/prod-marker   gt                  storageos.feature.replicas=1   add                 env=prod
default/uat-marker    lt                  storageos.feature.replicas=2   add                 env=uat
```
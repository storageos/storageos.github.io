---
layout: guide
title: StorageOS Docs - Selectors
anchor: manage
module: manage/selectors
---

# Selectors

A client or user can identify a set of objects using a label selector. StorageOS
selectors work the same as Kubernetes selectors.

The API currently supports two types of selectors: equality-based and set-based.
A label selector can be made of multiple requirements which are comma-separated.
In the case of multiple requirements, all must be satisfied so the comma
separator acts as an AND logical operator.

An empty label selector (that is, one with zero requirements) selects every
object in the collection.

A null label selector (which is only possible for optional selector fields)
selects no objects. Note: the label selectors of two controllers must not
overlap within a namespace, otherwise they will fight with each other.

## Equality-based requirement

Equality- or inequality-based requirements allow filtering by label keys and
values. Matching objects must satisfy all of the specified label constraints,
though they may have additional labels as well. Three kinds of operators are
admitted `=`,`==`,`!=`. The first two represent equality (and are simply
synonyms), while the latter represents inequality. For example:

```bash
environment = production
tier != frontend
```

The former selects all resources with key equal to `environment` and value equal
to `production`. The latter selects all resources with key equal to `tier` and
value distinct from `frontend`, and all resources with no labels with the `tier`
key. You can filter for resources in production excluding frontend using the
comma operator: `environment=production,tier!=frontend`

## Set-based requirement

Set-based label requirements allow filtering keys according to a set of values.
Three kinds of operators are supported: `in`, `notin` and `exists` (only the key
identifier). For example:

```bash
environment in (production, qa)
tier notin (frontend, backend)
partition
!partition
```

The first example selects all resources with key equal to `environment` and
value equal to `production` or `qa`. The second example selects all resources
with key equal to `tier` and values other than `frontend` and `backend`, and all
resources with no labels with the `tier` key. The third example selects all
resources including a label with key `partition`; no values are checked. The
fourth example selects all resources without a label with key `partition`; no
values are checked. Similarly the comma separator acts as an AND operator. So
filtering resources with a `partition` key (no matter the value) and with
environment different than `qa` can be achieved using `partition,environment
notin (qa)`. The set-based label selector is a general form of equality since
`environment=production` is equivalent to `environment in (production)`;
similarly for `!=` and `notin`.

Set-based requirements can be mixed with equality-based requirements. For
example: `partition in (customerA, customerB),environment!=qa`.

## Using selectors with labels and rules

Normally a selector is used to filter on labels with the
`--selector` option.

```bash
$ storageos volume ls --selector=env=dev
NAMESPACE/NAME        SIZE                MOUNTED BY          MOUNTPOINT          STATUS              REPLICAS
default/volume-name   5GB                                                         active              0/0
```

However on rules, selectors define the conditions for triggering a rule. This
creates a rule that configures 2 replicas for volumes with the label `env=prod`:

```bash
$ storageos rule create --namespace default --selector 'env==prod' --label storageos.feature.replicas=2 replicator
default/replicator
```

See [creating and managing rules]({% link _docs/reference/cli/rule.md %}) for
more.

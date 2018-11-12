---
layout: guide
title: StorageOS Docs - Rules
anchor: concepts
module: concepts/rules
---

# Rules

Rules are used for managing data policy and placement using StorageOS features
such as replication, QoS and compression. They provide a way for operators to
define default charactistics (such as number of replicas).

Rules are defined using labels and selectors. When a volume is created, the
rules are evaluated to determine whether to apply the action.

An example business requirement might be that all production volumes are
replicated twice. This would be defined with a selector `env==prod`, and the
action would be to add the label `storageos.com/replicas=2`.

Rules can be created with the CLI or Web UI. See [Rules]({%link
_docs/operations/rules.md %}) for details.

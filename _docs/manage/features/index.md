---
layout: guide
title: StorageOS Docs - Labels
anchor: manage
module: manage/features/index
# Last reviewed by cheryl.hung@storageos.com on 2017-04-13
---

# StorageOS feature labels

Applying specific labels to volumes triggers compression, replication and other
storage features. No feature labels are present by default.

| Feature     | Label                           | Values         | Description                                              |
|:------------|:--------------------------------|:---------------|:---------------------------------------------------------|
| Caching     | `storageos.feature.nocache`     | true / false   | Switches off caching. |
| Compression | `storageos.feature.nocompress`  | true / false   | Switches off compression of data at rest and in transit. |
| Replication | `storageos.feature.replicas`    | integers [0, 5]| Replicates entire volume across nodes. Typically 1 replica is sufficient (2 copies of the data); more than 2 replicas is not recommended. |
| Failure mode | `storageos.com/failure.mode`   | strings [`soft`,`hard`,`alwayson`] | Soft failure mode works together with the failure tolerance. Hard is a mode where any loss in desired replicas count will mark volume as unavailable. AlwaysOn is a mode where as long as master is alive volume will be writable. |
| Failure tolerance | `storageos.com/failure.tolerance` | integers [0, 4] | Specifies how many failed replicas to tolerate, defaults to (Replicas - 1) if Replicas > 0, so if there are 2 replicas it will default to 1. |
| QoS         | `storageos.feature.throttle`    | true / false   | Deprioritizes traffic by reducing the rate of disk I/O.  |
| Placement   | `storageos.hint.master`         | Node hostname or uuid   | Requests master volume placement on the specified node.  Will use another node if request can't be satisfied. |


Feature labels are a powerful and flexible way to control storage features,
especially when combined with [rules]({% link _docs/reference/cli/rule.md %}).

To create a volume with a feature labels:

```bash
storageos volume create --label storageos.feature.throttle=true
```

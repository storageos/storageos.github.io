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

To set supported labels, use `storageos volume create --label storageos.feature.cache=true`:

| Feature     | Label                           | Values         | Description                                              |
|:------------|:--------------------------------|:---------------|:---------------------------------------------------------|
| Caching     | `storageos.feature.cache`       | true / false   | Improves read performance at the expense of more memory. |
| Compression | `storageos.feature.nocompress`  | true / false   | Switches off compression of data at rest and in transit. |
| Replication | `storageos.feature.replicas`    | integers [0, 5]| Replicates entire volume across nodes. Typically 1 replica is sufficient (2 copies of the data); more than 2 replicas is not recommended. |
| QoS         | `storageos.feature.throttle`    | true / false   | Deprioritizes traffic by reducing the rate of disk I/O.  |

Feature labels are a powerful and flexible way to control storage features,
especially when combined with [rules]({% link _docs/reference/cli/rule.md %}).

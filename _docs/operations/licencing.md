---
layout: guide
title: StorageOS Docs - Licencing
anchor: operations
module: operations/licencing
---

# Get a licence for a StorageOS cluster

Before getting a licence, you need to know the ID of your StorageOS cluster. This CLI command can print the cluster ID:

```bash
storageos licence inspect | jq -r .[].clusterID
```

Then log into [StorageOS Portal](https://my.storageos.com), go to [Licences page](https://my.storageos.com/licenses) and
follow the instructions on the page to generate a new licence key. Make sure that you input the correct cluster ID before
generating the licence.

# Apply a licence to a StorageOS cluster 

Copy the licence key to clipboard and apply the licence by the CLI command:

```bash
$ echo PASTE-THE-LICENCE-KEY-HERE | storageos licence apply --stdin
```

Read the [licence CLI command reference]({% link _docs/reference/cli/licence.md %}) for further information.

---
layout: guide
title: StorageOS Docs - Licencing
anchor: operations
module: operations/licencing
---

# Licencing

A newly installed StorageOS cluster includes an unregistered Basic licence,
which caps available storage space at 100GB.  To utilise more storage space, we
offer either a Developer (free with registration - 500GB) license or an
Enterprise (unlimited capacity - see below) license. This document explains how
to upgrade your license using either the GUI or CLI.

## Obtaining a Developer licence via the GUI

You can obtain and apply a Developer licence in web GUI automatically by
creating or logging in with a StorageOS account on the licence page of the
StorageOS web GUI: `http://ADVERTISE_IP:5707/#/licence`.

![Licence Login](/images/docs/operations/licencing/licence-login.png)

Wait a few seconds for the licence generation process to complete, at which
point your license will be visible. To inspect your license, click on the
"DETAILS" button as follows:

![Developer Licence](/images/docs/operations/licencing/developer-licence.png)

## Applying a previously obtained licence via the GUI

Occasionally we will issue licenses directly, e.g. by email or some other
off-line meanst status
. Too apply such keys, via the web GUI, visit
`http://ADVERTISE_IP:5705/#/licence` and click on the tab "ENTER KEY", then
paste the licence key and click on "UPLOAD KEY TO CLUSTER". Note that you could
also view your cluster ID on the same page.

![Apply Licence Key](/images/docs/operations/licencing/apply-licence-key.png)

## Obtaining a Developer licence via the CLI

Before getting a licence, you need to know the ID of your StorageOS cluster.

This CLI command can print the cluster ID:

```bash
storageos licence inspect | jq -r .[].clusterID
```

To obtain a licence for your StorageOS cluster, create a new StorageOS account
or log into [StorageOS Portal](https://my.storageos.com), go to [Licences
page](https://my.storageos.com/licenses) and follow the instructions on the
page to get the licence key for your cluster. Make sure that you input the
correct cluster ID before generating the licence key.

![Get Licence](/images/docs/operations/licencing/get-licence.png)

Then copy the licence key to clipboard and apply the licence by the CLI command:

```bash
$ echo PASTE-THE-LICENCE-KEY-HERE | storageos licence apply --stdin
```

Read the [licence CLI command reference]({% link _docs/reference/cli/licence.md
%}) for further information.

## Obtaining an Enterprise licence

Please contact [info@storageos.com](mailto:info@storageos.com) to discuss
pricing for our Enterprise license.




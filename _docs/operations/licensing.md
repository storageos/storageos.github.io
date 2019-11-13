---
layout: guide
title: StorageOS Docs - Licensing
anchor: operations
module: operations/licensing
---

# Licensing

A newly installed StorageOS cluster includes an unregistered Basic licence,
which caps usable storage space at 50GB.  To utilise more storage space, we
offer either a Developer (free with registration - 500GB) licence or an
Enterprise (unlimited capacity - see below) licence. This document explains how
to upgrade your licence using either the GUI or CLI.

## Obtaining a Developer licence via the GUI

You can obtain and apply a Developer licence in the StorageOS web GUI
automatically by creating or logging in with a StorageOS account on the
StorageOS portal via the licence page of the StorageOS web GUI:
`http://ADVERTISE_IP:5705/#/licence`.

![Licence Login](/images/docs/operations/licensing/licence-login.png)

Wait a few seconds for the licence generation process to complete, at which
point your licence will be visible. To inspect your licence, click on the
"DETAILS" button as follows:

![Developer Licence](/images/docs/operations/licensing/developer-licence.png)

## Applying a previously obtained licence via the GUI

Occasionally we will issue licences directly, e.g. by email or some other
off-line method. To apply such keys, via the web GUI, visit
`http://ADVERTISE_IP:5705/#/licence` and click on the tab "ENTER KEY", then
paste the licence key and click on "UPLOAD KEY TO CLUSTER". Note that you could
also view your cluster ID on the same page.

![Apply Licence Key](/images/docs/operations/licensing/apply-licence-key.png)

## Obtaining a Developer licence via the CLI

Before getting a licence, you need to know the ID of your StorageOS cluster.

This CLI command can print the cluster ID:

```bash
storageos licence inspect | jq -r .[].arrayUUID
```

To obtain a licence for your StorageOS cluster, create a new StorageOS account
or log into [StorageOS Portal](https://my.storageos.com), go to the [Licences
page](https://my.storageos.com/licenses) and follow the instructions on the
page to get the licence key for your cluster. Make sure that you input the
correct cluster ID before generating the licence key.

![Get Licence](/images/docs/operations/licensing/get-licence.png)

Then copy the licence key to clipboard and apply the licence by the CLI command:

```bash
$ echo PASTE-THE-LICENCE-KEY-HERE | storageos licence apply --stdin
```

Read the [licence CLI command reference]({% link _docs/reference/cli/licence.md
%}) for further information.

## Obtaining an Enterprise licence

Please contact [sales@storageos.com](mailto:sales@storageos.com) to discuss
pricing for our Enterprise licence.




---
layout: guide
title: StorageOS Docs - Licencing
anchor: operations
module: operations/licencing
---

# Licencing

A newly installed StorageOS cluster includes an unregistered basic licence, which could only utilize maximum 100GB
storage space. You need to get a developer licence (maximum 500GB) or professional licence (unlimited capacity) and
apply it to the cluster in order to utilize more storage space.

## Know your StorageOS cluster ID

Before getting a licence, you need to know the ID of your StorageOS cluster.

This CLI command can print the cluster ID:

```bash
storageos licence inspect | jq -r .[].clusterID
```

An alternative way is to view your cluster ID on the web GUI, visit `http://ADVERTISE_IP:5705/#/licence` and click on
the tab "ENTER KEY":

![View Cluster ID](/images/docs/operations/licencing/view-cluster-id.png)

## Get a licence for a StorageOS cluster

To get a licence for your StorageOS cluster, create a new StorageOS account or log into
[StorageOS Portal](https://my.storageos.com), go to [Licences page](https://my.storageos.com/licenses) and follow the
instructions on the page to get the licence key for your cluster. Make sure that you input the correct cluster ID before
generating the licence key.

![Get Licence](/images/docs/operations/licencing/get-licence.png)

## Apply a licence to a StorageOS cluster 

Copy the licence key to clipboard and apply the licence by the CLI command:

```bash
$ echo PASTE-THE-LICENCE-KEY-HERE | storageos licence apply --stdin
```

Read the [licence CLI command reference]({% link _docs/reference/cli/licence.md %}) for further information.

Alternatively, you could apply the licence key by uploading the key within the web GUI. Again, visit
`http://ADVERTISE_IP:5705/#/licence` and click on the tab "ENTER KEY", then paste the licence key and click on "UPLOAD
KEY TO CLUSETER".

![Apply Licence Key](/images/docs/operations/licencing/apply-licence-key.png)

## Get and apply a developer licence in the web GUI

If you are getting a developer licence through the web GUI, you could get and apply it directly in web GUI simply by
creating or logging in with a StorageOS account on `http://ADVERTISE_IP:5705/#/licence`, without having to go through
the steps above.
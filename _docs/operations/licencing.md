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

## Obtaining a developer licence via the GUI

You could get and apply a developer licence in web GUI automatically by creating or logging in with a StorageOS
account on the licence page of web GUI: `http://ADVERTISE_IP:5707/#/licence`.

![Licence Login](/images/docs/operations/licencing/licence-login.png)

Wait a few seconds for the licence generation process to complete, then you have got a developer licence. Then you could
click on the "DETAILS" button to view the capacity of the developer licence, like below:

![Developer Licence](/images/docs/operations/licencing/developer-licence.png)

## Obtaining a developer licence via the CLI

Before getting a licence, you need to know the ID of your StorageOS cluster.

This CLI command can print the cluster ID:

```bash
storageos licence inspect | jq -r .[].clusterID
```

To get a licence for your StorageOS cluster, create a new StorageOS account or log into
[StorageOS Portal](https://my.storageos.com), go to [Licences page](https://my.storageos.com/licenses) and follow the
instructions on the page to get the licence key for your cluster. Make sure that you input the correct cluster ID before
generating the licence key.

![Get Licence](/images/docs/operations/licencing/get-licence.png)

Then copy the licence key to clipboard and apply the licence by the CLI command:

```bash
$ echo PASTE-THE-LICENCE-KEY-HERE | storageos licence apply --stdin
```

Read the [licence CLI command reference]({% link _docs/reference/cli/licence.md %}) for further information.

## Obtaining an enterprise licence

Customers can purchase StorageOS by capacity or node-based pricing. Contact
[info@storageos.com](mailto:info@storageos.com) to discuss.

## Applying an already got licence via GUI

If you would like to apply an already got licence to a StorageOS cluster via the web GUI, visit
`http://ADVERTISE_IP:5705/#/licence` and click on the tab "ENTER KEY", then paste the licence key and click on "UPLOAD
KEY TO CLUSTER". Note that you could also view your cluster ID on the same page.

![Apply Licence Key](/images/docs/operations/licencing/apply-licence-key.png)



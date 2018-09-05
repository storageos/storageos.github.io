---
layout: guide
title: StorageOS Docs - GUI
anchor: reference
module: reference/gui
---

# Graphical user interface (GUI)

StorageOS provides a GUI for cluster and volume management.

The GUI is available at port 5705 on any of the nodes in the cluster. Initally
you can log in as the default administrator, using the username `storageos` and
password `storageos`.

![Logging in](/images/docs/gui/login.png)

## Manage cluster nodes and pools

The nodes and pools page allow you to manage cluster nodes and storage pool. In this example, this cluster consists of three nodes with 35.9GB capacity each. The default storage pool contains all three nodes, giving a total of 107.6GB.

![Managing nodes](/images/docs/gui/nodes.png)
![Managing storage pools](/images/docs/gui/pools.png)

## Create and view volumes

You can create volumes, including replicated volumes, and view volume details:

![Creating a volume](/images/docs/gui/create-volume.png)
![Viewing storage volumes](/images/docs/gui/volumes.png)
![Viewing details of a volume](/images/docs/gui/volume-details.png)

## Managing volumes with namespaces and rules

Volumes can be namespaced across different projects or teams, and you can switch namespace using the left hand panel:

![Viewing namespaces](/images/docs/gui/namespaces.png)

Data policy and placement is enforced using rules:

![Viewing rules](/images/docs/gui/rules.png)

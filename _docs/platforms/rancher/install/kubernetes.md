---
layout: guide
title: StorageOS Docs - Installing on Kubernetes 1.11
platform: rancher
platformUC: Rancher
k8s-version: 1.11
cmd: kubectl
anchor: platforms
module: platforms/rancher/install/kubernetes
redirect_from: /docs/install/schedulers/rancher
redirect_from: /docs/install/rancher
---

# Rancher Kubernetes

> Make sure the 
> [prerequisites for StorageOS]({%link  _docs/prerequisites/overview.md %}) are
> satisfied before proceeding.

&nbsp;


Options:
- [Rancher Catalog (Recommended)](#rancher-catalog-install)
- [Manual install](#manual-install)


&nbsp;

# Rancher Catalog install

StorageOS is a Certified application in the Rancher Catalog. You can install
StorageOS by using the Rancher application install.

1. Select the `System` project of your cluster

    ![install-1](/images/rancher-ui-green-bubbles/rancher-1.png)

1. Select the `Apps` tab and click `Launch`
    ![install-2](/images/rancher-ui-green-bubbles/rancher-2.png)

1. Search for StorageOS and click in the App
    ![install-3](/images/rancher-ui-green-bubbles/rancher-3.png)

1. Define the StorageOS cluster installation

    > The installation can be described by using a Yaml format or filling the Rancher form.

    &nbsp;

    It is suggested to ensure the right values for the following options:
    - [Cluster Operator]({%link _docs/reference/cluster-operator/index.md %}) NameSpace
    - Container Images to be used (if using private registries)
    - Conditional bootstrap of StorageOS after installing the Cluster Operator
    - StorageOS NameSpace (installing in kube-system will add StorageOS to a
      priority class)
    - Default Username/Password for the StorageOS admin user
    - Key-value store [setup]({%link _docs/operations/external-etcd/index.md %})
    - Node Selectors and Tolerations

    &nbsp;

    ![install-4](/images/rancher-ui-green-bubbles/rancher-4.png)
    ![install-5](/images/rancher-ui-green-bubbles/rancher-5.png)

1. Verify the boostrap of the cluster

    ![install-6](/images/rancher-ui-green-bubbles/rancher-6.png)

&nbsp;

# Manual install

{% include operator/manual-install-disclaimer.md %}

{% include operator/install.md %}

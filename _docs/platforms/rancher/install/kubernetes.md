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

    > Minimal configuration to bootstrap StorageOS is set using default
    > values of the form. For full control to tune the installation, you can
    > use the yaml definition.

    &nbsp;

    The options to take in consideration for not minimal installations are the
    following:
    - [Cluster Operator]({%link _docs/reference/cluster-operator/index.md %}) NameSpace
    : The Kubernetes NameSpace where the StorageOS Cluster Operator controller
    and other resources will be created.
    - Container Images
    : Default images are pulled from DockerHub, you can specify the image URLs
    if using private registries.
    - Conditional bootstrap of StorageOS
    : Deployment of StorageOS after installing the Cluster Operator.
    If set to `false`, the Operator will be created, but the Custom Resource will
    not be applied to the cluster. Check the Operator [documentation]({%link _docs/reference/cluster-operator/configuration.md %}) and [CR examples]({%link _docs/reference/cluster-operator/examples.md %}) for more information.
    - StorageOS NameSpace
    : The Kubernetes NameSpace where StorageOS will be installed. Installing in kube-system will add StorageOS to a
      priority class to ensure proper resource priority allocation.
    - Username/Password
    : Default Username and Password for the admin account to be created at
    StorageOS bootstrap. Generate random passwords by clicking the `Generate`
    button.

    - Key-value store [setup]({%link _docs/operations/external-etcd/index.md %})
    : Configuration and details of the key-value store setup that StorageOS
    will use for its configuration. Settings such as external etcd with TLS
    termination are available.
    - Node Selectors and Tolerations
    : Placement of StorageOS DaemonSet Pods. StorageOS will be installed only
    in the nodes selected, in conjunction with any needed toleration for the
    Pods.

    &nbsp;

    ![install-4](/images/rancher-ui-green-bubbles/rancher-4.png)
    ![install-5](/images/rancher-ui-green-bubbles/rancher-5.png)

1. Verify the boostrap of the cluster

    ![install-6](/images/rancher-ui-green-bubbles/rancher-6.png)

&nbsp;

# Manual install

{% include operator/manual-install-disclaimer.md %}

{% include operator/install.md %}

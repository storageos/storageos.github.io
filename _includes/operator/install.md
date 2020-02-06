The StorageOS Cluster Operator is a [Kubernetes native
application](https://kubernetes.io/docs/concepts/extend-kubernetes/extend-cluster/)
developed to deploy and configure StorageOS clusters, and assist with
maintenance operations. We recommend its use for standard installations.

The operator is a Kubernetes controller that watches the `StorageOSCluster`
CRD. Once the controller is ready, a StorageOS cluster definition can be
created. The operator will deploy a StorageOS cluster based on the
configuration specified in the cluster definition.

&nbsp;

**Helm Note:** If you want to use [Helm](https://helm.sh/docs/) to install StorageOS, follow
the [StorageOS Operator Helm
Chart](https://github.com/storageos/charts/tree/master/stable/storageos-operator#installing-the-chart)
documentation.


## __Steps to install StorageOS:__

- [Install StorageOS Operator](#1-install-storageos-operator)
- [Create a Secret for default username and password](#2-create-a-secret)
- [Trigger bootstrap using a CustomResource](#3-trigger-a-storageos-installation)
{% if page.oc-version contains '4.' -%}
- [Set SELinux Permissions](#4-set-selinux-permissions)
{% endif %}

## 1. Install StorageOS operator

Install the StorageOS operator using the following yaml manifest.

```bash
{{ page.cmd }} create -f https://github.com/storageos/cluster-operator/releases/download/{{ site.latest_operator_version }}/storageos-operator.yaml
```


### Verify the Cluster Operator Pod Status

```bash
[root@master03]# {{ page.cmd }} -n storageos-operator get pod
NAME                                         READY     STATUS    RESTARTS   AGE
storageoscluster-operator-68678798ff-f28zw   1/1       Running   0          3m
```

> The READY 1/1 indicates that `storageoscluster` resources can be created.

## 2. Create a Secret

Before deploying a StorageOS cluster, create a Secret defining the StorageOS
API Username and Password in base64 encoding.

The API username and password are used to create the default StorageOS admin
account which can be used with the StorageOS CLI and to login to the StorageOS
GUI. The account defined in the secret is also used by Kubernetes to
authenticate against the StorageOS API when installing with the native driver.

```bash
{{ page.cmd }} create -f - <<END
apiVersion: v1
kind: Secret
metadata:
  name: "storageos-api"
  namespace: "storageos-operator"
  labels:
    app: "storageos"
type: "kubernetes.io/storageos"
data:
  # echo -n '<secret>' | base64
  apiUsername: c3RvcmFnZW9z
  apiPassword: c3RvcmFnZW9z
END
```

This example contains a default password, for production installations, use a
unique, strong password.

> You can define a base64 value by `echo -n "mystring" | base64`.

> Make sure that the encoding of the credentials doesn't have special characters such as '\n'.
> The `echo -n` ensures that a trailing new line is not appended to the string.

> If you wish to change the default accounts details post-install please see [Managing
> Users](/docs/operations/users#altering-the-storageos-api-account)

## 3. Trigger a StorageOS installation

{% if page.platform == "azure-aks" %}
{% include operator/cr-csi-example.md %}
{% elsif page.platform == "rancher" or page.platform == "dockeree" %}
{% include operator/cr-csi-shareddir.md %}
{% elsif page.oc-version contains '4.' %}
{% include operator/cr-csi-openshift4.md %}
{% elsif page.platform == "kubernetes" %}
{% assign k8s-version = page.k8s-version | plus: 0 %}
{% if k8s-version >= 1.13 %}
{% include operator/cr-csi-example.md %}
{% else %}
{% include operator/cr-basic-example.md %}
{% endif %}
{% else %}
{% include operator/cr-basic-example.md %}
{% endif %}

### Verify StorageOS Installation

```bash
[root@master03]# {{ page.cmd }} -n storageos get pods -w
NAME                                    READY   STATUS    RESTARTS   AGE
storageos-daemonset-75f6c               3/3     Running   0          3m
storageos-daemonset-czbqx               3/3     Running   0          3m
storageos-daemonset-zv4tq               3/3     Running   0          3m
storageos-scheduler-6d67b46f67-5c46j    1/1     Running   6          3m

```

> The above command watches the Pods created by the Cluster Definition example. Note that pods typically take approximately 65 seconds to enter the Running Phase.

{% if page.oc-version contains '4.' %}
## 4. Set SELinux Permissions
{% include platforms/openshift4-selinux.md %}
{% endif %}

{% include operator/first-volume.md %}

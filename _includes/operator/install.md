

__Steps to install StorageOS:__

- [Install StorageOS Operator](#1-install-storageos-operator)
- [Create a Secret for default username and password](#2-create-a-secret)
- [Trigger bootstrap using a CustomResource](#3-trigger-a-storageos-installation)

## 1. Install StorageOS operator

Our cluster operator is a [Kubernetes native
application](https://kubernetes.io/docs/concepts/extend-kubernetes/extend-cluster/)
developed to deploy and configure StorageOS clusters, and assist with
maintenance operations. We recommend its use for standard installations. 

The operator is a Kubernetes controller that watches the `StorageOSCluster`
CRD. Once the controller is ready, a StorageOS cluster definition can be
created. The operator will deploy a StorageOS cluster based on the
configuration specified in the cluster definition.

### Install

The StorageOS Cluster Operator can be installed with two options.

* Using Helm
* Standard yaml manifests


### (Option 1) Using Helm
```bash
helm repo add storageos https://charts.storageos.com
helm install storageos/storageoscluster-operator --namespace storageos-operator
```

> The Helm chart can be found in the [Charts public
> repository](https://github.com/storageos/charts).

> The StorageOS Cluster Operator source code can be found in the
> [cluster-operator repository](https://github.com/storageos/cluster-operator).

> The helm server, tiller, needs privileges to be able to deploy the StorageOS
> Cluster Operator. You can add the service account to the cluster-admin role
> for simplicity or create a role that matches the cluster-operator requirements.


### (Option 2) Standard yaml manifests

Install the StorageOS operator using yaml manifests

```bash
{{ page.cmd }} create -f https://github.com/storageos/cluster-operator/releases/download/{{ site.latest_operator_version }}/storageos-operator.yaml
```

### Verify the Cluster Operator Pod Status
```bash
[root@master03]# {{ page.cmd }} -n storageos-operator get pod
NAME                                         READY     STATUS    RESTARTS   AGE
storageoscluster-operator-68678798ff-f28zw   1/1       Running   0          3m
```

> The READY 1/1 indicates that `stos` resources can be created.

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
  namespace: "default"
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
{% else %}
{% include operator/cr-basic-example.md %}
{% endif %}

If this is your first installation you may wish to follow the [StorageOS
Volume guide](/docs/platforms/{{ page.platform }}/firstvolume/) for an example of how
to mount a StorageOS volume in a Pod. 

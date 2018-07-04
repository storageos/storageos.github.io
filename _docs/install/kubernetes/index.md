---
layout: guide
title: StorageOS Docs - Kubernetes
anchor: install
module: install/kubernetes
redirect_from: /docs/install/schedulers/kubernetes
---

# Install with Kubernetes

StorageOS can be used as a storage provider for your Kubernetes cluster, making
local storage accessible from any node within the Kubernetes cluster.  Data can
be replicated to protect against node failure.

At its core, StorageOS provides block storage.  You may choose the filesystem
type to install to make devices usable from within containers.

[**Try it in your browser for up to one hour >>**](https://play.storageos.com/k8s-sandbox)

## Prerequisites

You will need a Kubernetes 1.8+ cluster with Beta APIs enabled. The following prerequisites are met by default for Kubernetes 1.10+. 

1. Install [StorageOS CLI]({%link _docs/reference/cli/index.md %}).
1. Make sure your docker installation has mount propagation enabled.
    ```
   # A successful run is proof of mount propagation enabled
   docker run -it --rm -v /mnt:/mnt:shared busybox sh -c /bin/date

   # In case you see the error, docker: Error response from daemon: linux mounts: Could not find source mount of /mnt
   # you can enable mount propagation by overriding the MountFlag argument
   mkdir -p /etc/systemd/system/docker.service.d/
   cat <<EOF > /etc/systemd/system/docker.service.d/mount_propagtion_flags.conf
   [Service]
   MountFlags=shared
   EOF

   systemctl daemon-reload
   systemctl restart docker.service
    ```

1. Enable `MountPropagation` in Kubernetes (the procedure to enable mount propagation flags depends on the cluster's boot procedure):
 - Append flag `--feature-gates MountPropagation=true` to the deployments kube-apiserver and kube-controller-manager, usually found under `/etc/kubernetes/manifests` in the master node.
 - Add flag in the kubelet service config `KUBELET_EXTRA_ARGS=--feature-gates=MountPropagation=true`. For systemd, this usually is located in `/etc/systemd/system/`.

1. For deployments where the kubelet runs in a container (eg. [OpenShift]({%link _docs/install/openshift/index.md %}), CoreOS,
Rancher), add `--volume=/var/lib/storageos:/var/lib/storageos:rshared` to each
of the kubelets. This will be [fixed](https://github.com/kubernetes/kubernetes/pull/58816) in Kubernetes 1.10+.

For Kubernetes 1.7, you can [install the container directly in
Docker]({%link _docs/install/docker/index.md %}).

## Installation

You can install StorageOS with Helm or creating Kubernetes spec files.

## Install with Helm

Firstly, [install Helm](https://docs.helm.sh/using_helm). If you are running a rbac enabled cluster, you will need to create a [service account](https://github.com/kubernetes/helm/blob/master/docs/rbac.md).

The StorageOS helm chart triggers an [init container](https://github.com/storageos/init) to enable required kernel configuration on your host. If that procedure doesn't finish successfully, StorageOS container will not start.

If that is the case, check out the [os support](/docs/reference/os_support) page as you can manually prepare the settings for the kernel.

```bash
$ git clone https://github.com/storageos/helm-chart.git storageos
$ cd storageos
$ helm install --name my-release .

# Follow the instructions printed by helm install to update the link between Kubernetes and StorageOS.
$ ClusterIP=$(kubectl get svc/storageos --namespace kube-system -o custom-columns=IP:spec.clusterIP --no-headers=true)
$ ApiAddress=$(echo -n "tcp://$ClusterIP:5705" | base64)
$ kubectl patch secret/storageos-api --namespace kube-system --patch "{\"data\":{\"apiAddress\": \"$ApiAddress\"}}"
```

To uninstall the release with all related Kubernetes components:

```bash
$ helm delete --purge my-release
```

[See further configuration options.](https://github.com/storageos/helm-chart#configuration)

## Install without Helm

1. Create service account

    ```
   kubectl create -f - <<END
   apiVersion: v1
   kind: ServiceAccount
   metadata:
     name: storageos
     labels:
       app: storageos
   END
    ```

1. Create role

    ```
   kubectl create -f - <<END
   apiVersion: rbac.authorization.k8s.io/v1
   kind: Role
   metadata:
     name: storageos
     labels:
       app: storageos
   rules:
   - apiGroups:
       - ""
     resources:
       - secrets
     verbs:
       - create
       - get
       - list
       - delete
   END
    ```

1. Create role binding

    ```
   kubectl create -f - <<END
   apiVersion: rbac.authorization.k8s.io/v1
   kind: RoleBinding
   metadata:
     name: storageos
     labels:
       app: storageos
   roleRef:
     apiGroup: rbac.authorization.k8s.io
     kind: Role
     name: storageos
   subjects:
     - kind: ServiceAccount
       name: storageos
   END
    ```

1. Create StorageOS service

    ```
   kubectl create -f - <<END
   apiVersion: v1
   kind: Service
   metadata:
     name: storageos
     namespace: default
     labels:
       app: storageos
   spec:
     type: ClusterIP
     ports:
       - port: 5705
         targetPort: 5705
         protocol: TCP
         name: storageos
     selector:
       app: storageos
   END
    ```


1. Create secret

    ```
   CLUSTER_IP=$(kubectl get svc/storageos -o custom-columns=IP:spec.clusterIP --no-headers=true)
   API_ADDRESS=$(echo -n "tcp://$CLUSTER_IP:5705" | base64)
   kubectl create -f - <<END
   apiVersion: v1
   kind: Secret
   metadata:
     name: storageos-api
     namespace: default
     labels:
       app: storageos
   type: "kubernetes.io/storageos"
   data:
     # Address build from the ClusterIP of the storageos service. In the format $(echo -n "tcp://$ClusterIP:5705" | base64)
     apiAddress: "$API_ADDRESS"
     apiUsername: "c3RvcmFnZW9z"
     apiPassword: "c3RvcmFnZW9z"
   END
    ```

    The secret hosts information regarding the API endpoint of StorageOS. It is required to add the StorageOS service IP in base64 for the `apiAddress` field.

    `apiUsername` and `apiPassword` also need to be specified in base64. This example uses `echo "storageos" | base64` for both fields.

1. Create storage class

    ```
   kubectl create -f - <<END
   apiVersion: storage.k8s.io/v1beta1
   kind: StorageClass
   metadata:
     name: fast
     labels:
       app: storageos
   provisioner: kubernetes.io/storageos
   parameters:
     pool: default
     description: Kubernetes volume
     fsType: ext4
     adminSecretNamespace: default
     adminSecretName: storageos-api
   END
    ```

    StorageOS uses a secret to discover the API endpoint of its workers. `adminSecretNamespace` must be set to the specified namespace, and the service account needs to have granted permissions to StorageOS pods to have access to that secret.


1. Create DaemonSet

    StorageOS server pod runs as a daemonset, therefore all nodes in your cluster will have a StorageOS worker. If you want to limit the amount of nodes in the StorageOS cluster
    or enforce which Kubernetes nodes run storage workloads, you can define `spec.nodeSelector` based on node tags. For more information check [here](https://kubernetes.io/docs/concepts/configuration/assign-pod-node).

    ```
   # Get a cluster token id
   JOIN=$(storageos cluster create)

   kubectl create -f - <<END
   kind: DaemonSet
   apiVersion: apps/v1
   metadata:
     name: storageos
     namespace: default
   spec:
     selector:
       matchLabels:
         app: storageos
     template:
       metadata:
         name: storageos
         labels:
           app: storageos
       spec:
         hostPID: true
         hostNetwork: true
         serviceAccountName: storageos
         initContainers:
         - name: enable-lio
           image: storageos/init:0.1
           imagePullPolicy: Always
           volumeMounts:
             - name: kernel-modules
               mountPath: /lib/modules
               readOnly: true
             - name: sys
               mountPath: /sys
               mountPropagation: Bidirectional
           securityContext:
             privileged: true
             capabilities:
               add:
               - SYS_ADMIN
         containers:
         - name: storageos
           image: "storageos/node:1.0.0-rc1"
           imagePullPolicy: IfNotPresent
           args:
           - server
           ports:
           - containerPort: 5705
             name: api
           livenessProbe:
             initialDelaySeconds: 65
             timeoutSeconds: 10
             failureThreshold: 5
             httpGet:
               path: /v1/health
               port: api
           readinessProbe:
             initialDelaySeconds: 65
             timeoutSeconds: 10
             failureThreshold: 5
             httpGet:
               path: /v1/health
               port: api
           resources:
               {}
           env:
           - name: HOSTNAME
             valueFrom:
               fieldRef:
                 fieldPath: spec.nodeName
           - name: JOIN
             value: "$JOIN"
           - name: ADVERTISE_IP
             valueFrom:
               fieldRef:
                 fieldPath: status.podIP
           - name: NAMESPACE
             value: default
           securityContext:
             privileged: true
             capabilities:
               add:
               - SYS_ADMIN
           volumeMounts:
             - name: fuse
               mountPath: /dev/fuse
             - name: state
               mountPath: /var/lib/storageos
               mountPropagation: Bidirectional
             - name: sys
               mountPath: /sys
         volumes:
         - name: kernel-modules
           hostPath:
             path: /lib/modules
         - name: fuse
           hostPath:
             path: /dev/fuse
         - name: sys
           hostPath:
             path: /sys
         - name: state
           hostPath:
             path: /var/lib/storageos
   END
    ```

---
layout: guide
title: StorageOS Docs - OpenShift
anchor: install
module: install/openshift
---

# Install with OpenShift

StorageOS can be used as a storage provider for your OpenShift cluster, making
local storage accessible from any node within the OpenShift cluster.  Data can
be replicated to protect against node failure.

At its core, StorageOS provides block storage.  You may choose the filesystem
type to install to make devices usable from within containers.

## Prerequisites

You will need an OpenShift 3.8+ cluster with Beta APIs enabled.


1. Install [StorageOS CLI](/docs/reference/cli/index).
1. Make sure your docker installation has mount propagation enabled.
```
# A successful run is proof that mount propagation is enabled
docker run -it --rm -v /mnt:/mnt:shared busybox sh -c /bin/date
```
1. The [iptables rules]({% link _docs/install/prerequisites/firewalls.md %}) required for StorageOS.
1. Enable the `MountPropagation` flag by appending feature gates to the api and controller (you can apply these changes using the Ansible Playbooks)
- Add to the KubernetesMasterConfig section (/etc/origin/master/master-config.yaml):

    ```
kubernetesMasterConfig:
  apiServerArguments:
    feature-gates:
    - MountPropagation=true
  controllerArguments:
    feature-gates:
    - MountPropagation=true
    ```

- Add to the feature-gates to the kubelet arguments (/etc/origin/node/node-config.yaml):

    ```
kubeletArguments:
  feature-gates:
  - MountPropagation=true
    ```
    
- **Warning:** Restarting OpenShift services can cause downtime in the cluster.
- Restart services in the MasterNode `origin-master-api.service`, `origin-master-controllers.service` and `origin-node.service`
- Restart service in all Nodes `origin-node.service`


For OpenShift 3.7, you can [install the container directly in
Docker]({%link _docs/install/docker/index.md %}).


## Installation

You can install StorageOS with Helm or creating Kubernetes spec files.

## Install with Helm

The StorageOS container needs privileged execution permissions. so a security context constraint must be added.

```bash
RELEASE=my-release # Name of the release for storageos Chart
oc --as system:admin create serviceaccount $RELEASE-storageos -n default
oc --as system:admin adm policy add-scc-to-user privileged system:serviceaccount:default:$RELEASE-storageos
```

[Install Helm](https://blog.openshift.com/getting-started-helm-openshift)

```bash
$ git clone https://github.com/storageos/helm-chart.git storageos
$ cd storageos
$ helm install --name $RELEASE .

# Follow the instructions printed by helm install to update the link between Kubernetes and StorageOS.
$ ClusterIP=$(kubectl get svc/storageos --namespace kube-system -o custom-columns=IP:spec.clusterIP --no-headers=true)
$ ApiAddress=$(echo -n "tcp://$ClusterIP:5705" | base64)
$ kubectl patch secret/storageos-api --namespace kube-system --patch "{\"data\":{\"apiAddress\": \"$ApiAddress\"}}"
```

To uninstall the release with all related Kubernetes components:

```bash
$ helm delete --purge $RELEASE
```

[See further configuration options.](https://github.com/storageos/helm-chart#configuration)

## Install without Helm

1. Create service account

    ```
    oc create -f - <<END
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
    oc create -f - <<END
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
    oc create -f - <<END
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

1. Add security context constraint policy
    ```
    # default namespace
    # service account: storageos
    oc adm policy add-scc-to-user privileged system:serviceaccount:default:storageos
    ```

    StorageOS needs privileged access as it interacts with the underlying host's OS to provide storage.

1. Create StorageOS service

    ```
    oc create -f - <<END
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
    CLUSTER_IP=$(oc get svc/storageos -o custom-columns=IP:spec.clusterIP --no-headers=true)
    API_ADDRESS=$(echo -n "tcp://$CLUSTER_IP:5705" | base64)
    oc create -f - <<END
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
    oc create -f - <<END
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

    StorageOS server pod runs as a daemonset, therefore all instances of your cluster will have a StorageOS worker. In case that you want to limit the amount of nodes in the StorageOS cluster
    or make sure which Kubernetes nodes run storage workloads, you can define `spec.nodeSelector` based on node tags. For more information check [here](https://kubernetes.io/docs/concepts/configuration/assign-pod-node).

    ```
    # Get a cluster token id
    JOIN=$(storageos cluster create)

    oc create -f - <<END
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

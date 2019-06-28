This is an example.

    ```bash
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
     apiUsername: c3RvcmFnZW9z # Define your own user and password
     apiPassword: c3RvcmFnZW9z
   ---
   apiVersion: "storageos.com/v1"
   kind: StorageOSCluster
   metadata:
     name: "storageos"
   spec:
     k8sDistro: "rancher"
     namespace: "kube-system"
     secretRefName: "storageos-api" # Reference from the Secret created in the previous step
     secretRefNamespace: "storageos-operator"  # Namespace of the Secret
     csi:
       enable: true
       deploymentStrategy: "deployment"
     images:
       nodeContainer: "storageos/node:{{ site.latest_node_version }}" # StorageOS version
   #  kvBackend:
   #    address: 'storageos-etcd-client.etcd:2379' # Example address, change for your etcd endpoint
   #    backend: 'etcd'
     sharedDir: '/var/lib/kubelet/plugins/kubernetes.io~storageos' # Needed when Kubelet as a container
     resources:
       requests:
         memory: "512Mi"
     nodeSelectorTerms:
       - matchExpressions:
         - key: "node-role.kubernetes.io/worker"
           operator: In
           values:
           - "true"
    ```

    > `spec` parameters available on the [Cluster Operator configuration](
    > {%link _docs/reference/cluster-operator/configuration.md %}) page.

    > You can find more examples such as deployments referencing a external etcd kv
    > store for StorageOS in the [Cluster Operator examples](
    > {%link _docs/reference/cluster-operator/examples.md %}) page.

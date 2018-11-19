This is a Cluster Definition example. 

```bash
{{ page.cmd }} create -f - <<END
apiVersion: "storageos.com/v1alpha1"
kind: "StorageOSCluster"
metadata:
  name: "example-storageos"
spec:
  secretRefName: "storageos-api" # Reference from the Secret created in the previous step
  secretRefNamespace: "default"  # Namespace of the Secret
  images:
    nodeContainer: "storageos/node:{{ site.latest_node_version }}" # StorageOS version
  csi:
    enable: true
  resources:
    requests:
    memory: "512Mi"
END
```

> `spec` parameters available on the [Cluster Operator configuration](
> {%link _docs/reference/cluster-operator/configuration.md %}) page.

> You can find more examples such as deployments referencing a external etcd kv
> store for StorageOS in the [Cluster Operator examples](
> {%link _docs/reference/cluster-operator/examples.md %}) page.

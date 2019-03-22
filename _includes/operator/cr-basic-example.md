This is a Cluster Definition example.

{% if page.platform == "openshift" %}
```bash
{{ page.cmd }} create -f - <<END
apiVersion: "storageos.com/v1alpha1"
kind: "StorageOSCluster"
metadata:
  name: "example-storageos"
spec:
  secretRefName: "storageos-api" # Reference the Secret created in the previous step
  secretRefNamespace: "default"  # Namespace of the Secret
  images:
    nodeContainer: "storageos/node:{{ site.latest_node_version }}" # StorageOS version
  resources:
    requests:
    memory: "512Mi"
  nodeSelectorTerms:
    - matchExpressions:
      - key: "node-role.kubernetes.io/compute"
        operator: In
        values:
        - "true"
END
```
{% elsif page.platform == "rancher" %}
```bash
{{ page.cmd }} create -f - <<END
apiVersion: "storageos.com/v1alpha1"
kind: "StorageOSCluster"
metadata:
  name: "example-storageos"
spec:
  secretRefName: "storageos-api" # Reference the Secret created in the previous step
  secretRefNamespace: "default"  # Namespace of the Secret
  images:
    nodeContainer: "storageos/node:{{ site.latest_node_version }}" # StorageOS version
  resources:
    requests:
    memory: "512Mi"
  sharedDir: '/var/lib/kubelet/volumeplugins/kubernetes.io~storageos'
  nodeSelectorTerms:
    - matchExpressions:
      - key: "node-role.kubernetes.io/worker"
        operator: In
        values:
        - "true"
END
```
{% else %}
```bash
{{ page.cmd }} create -f - <<END
apiVersion: "storageos.com/v1alpha1"
kind: "StorageOSCluster"
metadata:
  name: "example-storageos"
spec:
  secretRefName: "storageos-api" # Reference the Secret created in the previous step
  secretRefNamespace: "default"  # Namespace of the Secret
  images:
    nodeContainer: "storageos/node:{{ site.latest_node_version }}" # StorageOS version
  resources:
    requests:
    memory: "512Mi"
END
```
{% endif %}

> `spec` parameters available on the [Cluster Operator configuration]({%link _docs/reference/cluster-operator/configuration.md %}) page.

> You can find more examples such as deployments with CSI or deployments referencing a external etcd kv store.
store for StorageOS in the [Cluster Operator examples]({%link _docs/reference/cluster-operator/examples.md %}) page.

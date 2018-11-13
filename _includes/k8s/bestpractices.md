
## StorageOS Pod placement

StorageOS must run on all nodes that will contribute storage capacity to
the cluster or that will host Pods which use StorageOS volumes. For production
environments, it is recommended not to place StorageOS Pods on Master nodes.

StorageOS is deployed with a DaemonSet controller, and therefore tolerates the
standard unschedulable taint placed on master nodes, and cordoned nodes (see
the Kubernetes
[docs](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)
for more details). To avoid scheduling StorageOS pods on master nodes, you can
add an arbitrary taint to them for which the StorageOS DaemonSet won't have a
toleration.

Be sure to appropriately modify the [JOIN]({%link
_docs/prerequisites/clusterdiscovery.md %}) variable defined for the DaemonSet
to avoid newly bootstrapping nodes trying to contact non-existent pods on
Kubernetes master nodes. If installing with our [Cluster Operator]({% link
_docs/reference/cluster-operator/index.md %}), this is handled for you automatically. 

## StorageOS API username/password

StorageOS uses a Kubernetes secret to define the API credentials. For standard
installations (non CSI), the API credentials are used by {{ page.platform }} to
communicate with StorageOS.

The API grants full access to StorageOS functionality, therefore we recommend
that the default administrative password of 'storageos' is reset to something
unique and strong.

You can change the default parameters by encoding the `apiUsername` and
`apiPassword` values (in base64) into the `storageos-api` secret.

To generate a unique password, a technique such as the following, which
generates a pseudo-random 24 character string, may be used:

```bash
# Generate strong password
PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*()_+~' | fold -w 24 | head -n 1)

# Convert password to base64 representation for embedding in a K8S secret
BASE64PASSWORD=$(echo $PASSWORD | base64)
```

Note that the Kubernetes secret containing a strong password *must* be created
before bootstrapping the cluster. Multiple installation procedures use this
Secret to create a StorageOS account when the cluster first starts.

## Use an external etcd cluster

StorageOS uses the `etcd` distributed key-value store to store essential
cluster metadata and manage distributed consensus. For production environments,
we recommend deploying using a external etcd cluster. For more details about
and an example of how to run etcd in {{ page.platform }}, see the [External
Etcd Operations]({%link _docs/operations/external-etcd.md %}) page.

## Setup of storage on the hosts

We recommend creating a separate filesystem for StorageOS to mitigate
risk of filling the root filesystem on nodes. This has to be done for each node
in the cluster.

Follow the [managing host storage]({%link _docs/operations/managing-host-storage.md
%}) best practices page for more details.

## Resource reservations

StorageOS resource consumption depends on the workloads and the StorageOS
features in use. Therefore the requirements vary according to each dimension of
the problem.

For production environments, it is recommended to test StorageOS under
realistic workloads and tune the resources accordingly.

The recommended minimum memory reservation for the StorageOS Pods is 235Mb.
However it is recommended to prepare nodes so StorageOS can operate at least
with 1-2GB of memory. StorageOS frees memory when possible.

StorageOS Pods resource allocation will impact directly on the availability of
the volumes in case of eviction or limit triggered restart. It is recommended
to not limit StorageOS Pods.

StorageOS implements a storage engine, therefore limiting CPU consumption might
affect the I/O throughput of your volumes.


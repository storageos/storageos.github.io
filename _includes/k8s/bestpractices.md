
## StorageOS Pod placement

StorageOS must run on nodes that will contribute storage capacity to the
cluster, and on nodes that will host Pods which use StorageOS volumes. For
production environments, it is recommended to not place StorageOS Pods on
Master nodes.

StorageOS is deployed with a DaemonSet controller. Therefore, the NoSchedule
toleration is added by default. To avoid collocation in master nodes, you can
add an arbitrary taint to them for which the StorageOS daemonset won't have a
toleration.

StorageOS uses a variable to facilitate the [discovery]({%link
_docs/prerequisites/clusterdiscovery.md %}) of peers in the cluster. This
variable must not point to nodes where StorageOS is not running.

The StorageOS Cluster Operator can handle the discovery and Pod collocation by
setting node affinity selectors. Other installation methods require to build
the `JOIN` variable. It is recommended to label your {{ page.platform }} nodes
to select where StorageOS must run.

## StorageOS API username/password

StorageOS uses a Kubernetes secret to define the API credentials. For standard
installations (non CSI), the API credentials are used by {{ page.platform }} to
communicate with StorageOS.

The API grants full access to StorageOS functionalities, therefore it is
recommended to set custom credentials.

You can change the default parameters by defining the `apiUsername` and
`apiPassword` values (in base64) adding them to the `storageos-api` secret.

> Make sure the base64 encoding doesn't have special characters
> For instance: `echo -n "myusername" | base64`

Multiple installation procedures use this Secret to create a StorageOS account
when the cluster first starts.

## KV store 

StorageOS uses a key-value store to store cluster metadata across the
distributed platform. For production environments, it is recommended to use a
external etcd cluster. For more details about why and how to run this
application in {{ page.platform }}, check the [External kv store]({%link
_docs/operations/external-kv.md %}) page.


## Setup of storage in the hosts

It is recommended to create an independent partition for the StorageOS directory
to avoid filling the `/` filesystem. This has to be done for each node in the
cluster.

Follow the [host configuration]({%link _docs/operations/storage-host-config.md %}) best practices page for more details.

## Resource reservations

StorageOS resource consumption depends on the workloads and the StorageOS
features in use. Therefore the requirements vary according to each dimension of
the problem.

For production environments, it is recommended to test StorageOS under
realistic workloads and tune the resources accordingly.

The recommended minimum memory reservation for the StorageOS Pods is 235Mb.
However it is recommended to prepare nodes so StorageOS can operate at least
with 1-2Gi of memory. StorageOS frees memory when possible.

StorageOS Pods resource allocation will impact directly on the availability of
the volumes in case of eviction or limit triggered restart. It is recommended
to not limit StorageOS Pods.

StorageOS implements a storage engine, therefore limiting CPU consumption might
affect the I/O throughput of your volumes.

### Caching

By default, volumes are cached to improve read performance and compressed to
reduce network traffic. The size of StorageOS's cache is determined according
to the available memory in the node.

| Available memory   | % of overall memory reserved by StorageOS for caching |
|:-------------------|:---------------------|
| 3 GB or less       | 3%                   |
| 3-8 GB             | 5%                   |
| 8-12 GB            | 7%                   |
| 12 GB or more      | 10%                  |

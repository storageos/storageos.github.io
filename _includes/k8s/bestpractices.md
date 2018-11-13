
## StorageOS Pod placement

StorageOS must run in nodes that will contribute with storage capacity to the
cluster, and the nodes that will host Pods which use StorageOS volumes. For
production environments, it is recommended to not place StorageOS Pods in
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
recommended to don't use default credentials. 

You can change the default parameters by defining the `apiUsername` and
`apiPassword` values (in base64) into the `storageos-api` secret.

> Make sure the base64 encoding doesn't have special characters
> For instance: `echo -n "myusername" | base64`

Multiple installation procedures use this Secret to create a StorageOS account
when the cluster first starts.

## KV store 

StorageOS uses a key-value store to keep cluster metadata across the
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

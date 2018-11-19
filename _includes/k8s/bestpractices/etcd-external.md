## Use an external etcd cluster

StorageOS uses the `etcd` distributed key-value store to store essential
cluster metadata and manage distributed configuration state. An embedded etcd
instance is included in the StorageOS container, but for production environments,
__we recommend deploying using a external etcd cluster.__ For more details about
and an example of how to run etcd, see the
[External Etcd Operations]({%link _docs/operations/external-etcd.md %})
page.

It is highly recommended to use external etcd for __cloud environments__ and
place the etcd cluster on stable nodes. Placing the etcd on nodes that are
recycled often might affect the normal operations of StorageOS.

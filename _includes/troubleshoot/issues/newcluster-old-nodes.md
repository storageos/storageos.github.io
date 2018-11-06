## Clearing cached `JOIN`

When trying out StorageOS in Dev/POC environments it is common to change the
value of the `JOIN` variable between installs. However, if a node has
previously participated in a cluster, the old `JOIN` value is cached and used
in preference. When re-installing StorageOS, you should clear the old cached
data:

```
$ rm -rf /var/lib/storageos*
```

> WARNING: this will remove any data stored on this node.

## Re-using an old cluster token

When re-installing StorageOS it is possible to make the mistake of using an old
cluster token from a previous install. This will cause the new StorageOS
install to attempt to join the old cluster, normally resulting in a failure.

```
$ docker plugin install --alias storageos storageos/plugin:0.9.2 JOIN=$PREVIOUS_CLUSTER_ID
0.9.2: Pulling from storageos/plugin
a4eba3fe5636: Download complete
Digest: sha256:4f4a87e1506b7357815f574ded1ef7fd53e94683ce9d802a134019dfd8e9580a
Status: Downloaded newer image for storageos/plugin:0.9.2
Installed plugin storageos/plugin:0.9.2

$ storageos cluster health
API not responding to list nodes: API error (Service Unavailable): KV Store Unavailable
```

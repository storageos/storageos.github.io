```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast-replica
parameters:
  fsType: ext4
  pool: default
  storageos.com/replicas: "1"
provisioner: storageos
```

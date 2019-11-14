```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-vol-1
spec:
  storageClassName: "fast-replica"
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
```

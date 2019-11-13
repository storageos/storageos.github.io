Kubernetes allows the use of different schedulers by setting the field
`.spec.schedulerName: storageos-scheduler`.

For instance the Pod manifest utilising the StorageOS scheduler would look as follows:

```bash
apiVersion: v1
kind: Pod
metadata:
  name: d1
spec:
  schedulerName: storageos-scheduler # --> StorageOS Scheduler
                                     # No need if using Admission Controller
                                     # (enabled by default)
  containers:
    - name: debian
      image: debian:9-slim
      command: ["/bin/sleep"]
      args: [ "3600" ]
      volumeMounts:
        - mountPath: /mnt
          name: v1
  volumes:
    - name: v1
      persistentVolumeClaim:
        claimName: persistent-volume # ----> StorageOS PVC

```

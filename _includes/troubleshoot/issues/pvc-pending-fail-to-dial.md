## PVC pending state - Failed to dial StorageOS

A created PVC remains in pending state making pods that need to mount that PVC
unable to start.

### Issue: 
```bash
root@node1:~/# {{ page.cmd }} get pvc
NAME      STATUS        VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
vol-1     Pending                                                                            fast           7s

{{ page.cmd }} describe pvc $PVC
(...)
Events:
  Type     Reason              Age               From                         Message
  ----     ------              ----              ----                         -------
  Warning  ProvisioningFailed  7s (x2 over 18s)  persistentvolume-controller  Failed to provision volume with StorageClass "fast": Get http://storageos-cluster/version: failed to dial all known cluster members, (10.233.59.206:5705)
```

### Reason:
For non CSI installations of StorageOS, {{ page.platform }} uses the StorageOS
API endpoint to communicate. If that communication fails, relevant actions such
as create or mount a volume can't be transmitted to StorageOS, hence the PVC
will remain in pending state. StorageOS never received the action to perform,
so it never sent back an acknowledgement.

In this case, the Event message indicates that StorageOS API is not responding,
implying that StorageOS is not running. For {{ page.platform }} to define
StorageOS pods ready, the health check must pass.

### Doublecheck:

Check the status of StorageOS pods.

```bash
root@node1:~/# {{ page.cmd }} -n storageos get pod --selector app=storageos # for CSI add --selector kind=daemonset
NAME              READY     STATUS    RESTARTS   AGE
storageos-qrqkj   0/1       Running   0          1m
storageos-s4bfv   0/1       Running   0          1m
storageos-vcpfx   0/1       Running   0          1m
storageos-w98f5   0/1       Running   0          1m
```

If the pods are not READY, the service will not forward traffic to the API they
serve hence PVC will remain in pending state until StorageOS pods are
available. 

> {{ page.platform }} keeps trying to execute the action until it succeeds. If
> a PVC is created before StorageOS finish starting, the PVC will be created
> eventually.

### Solution:
- StorageOS health check takes 60 seconds of grace before reporting as READY. If
StorageOS is starting properly after that period, the volume will be created
when StorageOS finishes its bootstrap.
- If StorageOS is not running or is not starting properly, the solution to this
issue is to make StorageOS start. Check the [troubleshooting
installation](/docs/platforms/{{ page.platform | downcase
}}/troubleshoot/install) or follow the [installation procedures]({%link
_docs/introduction/quickstart.md %})

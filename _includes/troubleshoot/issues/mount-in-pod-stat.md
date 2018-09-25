## Pod in pending because of mount error

### Issue:

The events of `{{ page.cmd }} describe pod $POD_ID` show the `no such file` error of the StorageOS volume device file.

```bash
  Normal   Scheduled         11s                default-scheduler  Successfully assigned default/d1 to node3
  Warning  FailedMount       4s (x4 over 9s)    kubelet, node3     MountVolume.SetUp failed for volume "pvc-f2a49198-c00c-11e8-ba01-0800278dc04d" : stat /var/lib/storageos/volumes/d9df3549-26c0-4cfc-62b4-724b443069a1: no such file or directory
```

### Reason:
Mount propagation is not enabled.

### Doublecheck:
SSH into the one of the nodes and check if `/var/lib/storageos/volumes` is empty. If so, exec into any StorageOS pod and check the same directory.
```bash
root@node1:~# ls /var/lib/storageos/volumes/
root@node1:~# 
root@node1:~# {{ page.cmd }} exec $POD_ID -c storageos -- ls -l /var/lib/storageos/volumes
bst-196004
d529b340-0189-15c7-f8f3-33bfc4cf03fa
ff537c5b-e295-e518-a340-0b6308b69f74
```

If the directory inside the container and the device files are visible, the mount propagation is the cause.


### Solution:

Enable mount propagation both for {{ page.platform }} and docker, following the [prerequisites page]({%link _docs/prerequisites/mountpropagation.md %})

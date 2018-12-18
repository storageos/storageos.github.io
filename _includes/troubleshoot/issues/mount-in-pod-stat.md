## Pod in pending because of mount error

### Issue:

The output of `{{ page.cmd }} describe pod $POD_ID` contains `no such file or
directory` and references the StorageOS volume device file.

```bash
root@node1:~# {{ page.cmd }} -n storageos describe $POD_ID
(...)
Events:
  (...)
  Normal   Scheduled         11s                default-scheduler  Successfully assigned default/d1 to node3
  Warning  FailedMount       4s (x4 over 9s)    kubelet, node3     MountVolume.SetUp failed for volume "pvc-f2a49198-c00c-11e8-ba01-0800278dc04d" : stat /var/lib/storageos/volumes/d9df3549-26c0-4cfc-62b4-724b443069a1: no such file or directory
```

### Reason:

{% if page.platform == "Rancher" %}

There are two main possible reasons for this issue to arise.
- The StorageOS `DEVICE_DIR` location is wrongly configured
- Mount Propagation is not enabled



(Option 1) Misconfiguration of the DeviceDir/SharedDir

Rancher deploys the kubelet as a container, because of that, the device files
that StorageOS creates to mount into the containers need to be visible by the
kubelet. StorageOS can be configured to share the device directory.

### Doubelcheck:

```bash
root@node1:~# {{ page.cmd }} -n default describe stos | grep "Shared Dir"
  Shared Dir:      # <-- Shouldn't be blank
```

### Solution:

The Cluster Operator Custom Definition should specify the SharedDir option as follows.

```bash
spec:
  sharedDir: '/var/lib/kubelet/volumeplugins/kubernetes.io~storageos' # Needed when Kubelet as a container
  ...
```

> See example for rancher
[CustomResource](https://github.com/storageos/deploy/blob/master/k8s/deploy-storageos/cluster-operator/examples/rancher/rancher-embedded-etcd.yaml).

&nbsp; <!-- this is a blank line -->

(Option 2) Mount propagation is not enabled.

> Applies only if Option 1 is configured properly.

### Doublecheck:
SSH into one of the nodes and check if
`/var/lib/kubelet/volumeplugins/kubernetes.io~storageos/devices` is empty. If
so, exec into any StorageOS pod and check the same directory.

```bash
root@node1:~# ls /var/lib/kubelet/volumeplugins/kubernetes.io~storageos/devices
root@node1:~#      # <-- Shouldn't be blank
root@node1:~# {{ page.cmd }} exec $POD_ID -c storageos -- ls -l /var/lib/kubelet/volumeplugins/kubernetes.io~storageos/devices
bst-196004
d529b340-0189-15c7-f8f3-33bfc4cf03fa
ff537c5b-e295-e518-a340-0b6308b69f74
```

If the directory inside the container and the device files are visible,
disabled mount propagation is the cause.


### Solution:

Older versions of Kubernetes require to enable mount propagation in the "View
in API" section of your cluster in Rancher. You need to edit the section
"rancherKubernetesEngineConfig" to enable the Kubelet feature gate.


{% else %}

Mount propagation is not enabled.

### Doublecheck:
SSH into one of the nodes and check if `/var/lib/storageos/volumes` is
empty. If so, exec into any StorageOS pod and check the same directory.

```bash
root@node1:~# ls /var/lib/storageos/volumes/
root@node1:~#     # <-- Shouldn't be blank
root@node1:~# {{ page.cmd }} exec $POD_ID -c storageos -- ls -l /var/lib/storageos/volumes
bst-196004
d529b340-0189-15c7-f8f3-33bfc4cf03fa
ff537c5b-e295-e518-a340-0b6308b69f74
```

If the directory inside the container and the device files are visible,
disabled mount propagation is the cause.


### Solution:

Enable mount propagation both for {{ page.platform }} and docker, following the
[prerequisites page]({%link _docs/prerequisites/mountpropagation.md %})

{% endif %}

## StorageOS pods missing -- DaemonSet error

StorageOS deployment doesn't have any pod replicas. The DaemonSet couldn't
allocate any Pod due to security issues.

### Issue:

```bash
[root@master02 standard]# {{ page.cmd }} get pod
No resources found.
[root@master02 standard]# {{ page.cmd }} describe daemonset storageos
(...)
Events:
  Type     Reason        Age                From                  Message
  ----     ------        ----               ----                  -------
  Warning  FailedCreate  0s (x12 over 10s)  daemonset-controller  Error creating: pods "storageos-" is forbidden: unable to validate against any security context constraint: [provider restricted: .spec.securityContext.hostNetwork: Invalid value: true: Host network is not allowed to be used provider restricted: .spec.securityContext.hostPID: Invalid value: true: Host PID is not allowed to be used spec.volumes[0]: Invalid value: "hostPath": hostPath volumes are not allowed to be used spec.volumes[1]: Invalid value: "hostPath": hostPath volumes are not allowed to be used spec.volumes[2]: Invalid value: "hostPath": hostPath volumes are not allowed to be used spec.volumes[3]: Invalid value: "hostPath": hostPath volumes are not allowed to be used spec.initContainers[0].securityContext.privileged: Invalid value: true: Privileged containers are not allowed capabilities.add: Invalid value: "SYS_ADMIN": capability may not be added spec.initContainers[0].securityContext.hostNetwork: Invalid value: true: Host network is not allowed to be used spec.initContainers[0].securityContext.containers[0].hostPort: Invalid value: 5705: Host ports are not allowed to be used spec.initContainers[0].securityContext.hostPID: Invalid value: true: Host PID is not allowed to be used spec.containers[0].securityContext.privileged: Invalid value: true: Privileged containers are not allowed capabilities.add: Invalid value: "SYS_ADMIN": capability may not be added spec.containers[0].securityContext.hostNetwork: Invalid value: true: Host network is not allowed to be used spec.containers[0].securityContext.containers[0].hostPort: Invalid value: 5705: Host ports are not allowed to be used spec.containers[0].securityContext.hostPID: Invalid value: true: Host PID is not allowed to be used]
```

### Reason:

This {{ page.platform }} cluster has security context constraint policies
enabled that forbid any pod, without the explicitly set policy for the service
account, to be allocated.

### Doublecheck:

Check if the StorageOS ServiceAccount can create pods with enough permissions

```bash
{{ page.cmd }} get scc privileged -o yaml # Or custom scc with enough privileges
(...)
users:
- system:admin
- system:serviceaccount:openshift-infra:build-controller
- system:serviceaccount:management-infra:management-admin
- system:serviceaccount:management-infra:inspector-admin
- system:serviceaccount:storageos:storageos                       <--
- system:serviceaccount:tiller:tiller
```

If the StorageOS sa system:serviceaccount:storageos:storageos is in the
privileged scc it will be able to create pods.

### Solution:

Add the ServiceAccount system:serviceaccount:storageos:storageos to a scc with
enough privieges.

```bash
{{ page.cmd }} adm policy add-scc-to-user privileged system:serviceaccount:storageos:storageos
```

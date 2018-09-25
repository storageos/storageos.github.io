## Node name different from Hostname

#### Issue:
StorageOS nodes can't join the cluster showing the following logs.

```bash
time="2018-09-24T13:47:02Z" level=error msg="failed to start api" error="error verifying UUID: UUID aed3275f-846b-1f75-43a1-adbfec8bf974 has already been registered and has hostname 'debian-4', not 'node4'" module=command
```
### Reason:

The StorageOS registration process to start the cluster uses the hostname of the node where StorageOS container is running, provided by {{ page.platform }}. However, StorageOS verifies the network hostname of the OS as a prestart check to make sure it can communicate with other nodes. If those 2 names don't match, StorageOS will remain unable to start.

### Solution:

Make sure the hostnames match with the {{ page.platform }} advertised names. If you have changed the hostname of your nodes, make sure that you restart the nodes to apply the change.


{% include troubleshoot/issues/one-node-multiple-clusters.md %}

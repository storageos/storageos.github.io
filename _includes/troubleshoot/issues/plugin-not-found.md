## StorageOs plugin not found

### Issue:

Docker logs indicate that it cannot find StorageOS plugin, even though the
StorageOS container is running.

### Reason:
Docker Swarm installations don't identify plugins that are registered as
containers, rather than docker plugins. Therefore some swarm installations
don't load plugins as expected.  Docker use lazy loading for those plugins that
start as containers. StorageOS creates a socket for which Docker can
communicate to the storage engine and provision volumes. 

### Solution:

Run a docker cli command related to a volume in order to trigger Docker's lazy
plugin evaluation. 

```bash
docker volume ls
```

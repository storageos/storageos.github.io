## PVC pending state - Secret Missing

A created PVC remains in pending state making pods that need to mount that PVC
unable to start.

### Issue: 
```bash
{{ page.cmd }} describe pvc $PVC
(...)
Events:
  Type     Reason              Age                From                         Message
  ----     ------              ----               ----                         -------
  Warning  ProvisioningFailed  13s (x2 over 28s)  persistentvolume-controller  Failed to provision volume with StorageClass "fast": failed to get secret from ["storageos"/"storageos-api"]

```

### Reason:
For non CSI installations of StorageOS, {{ page.platform }} uses the StorageOS
API endpoint to communicate. If that communication fails, relevant actions such
as create or mount a volume can't be transmitted to StorageOS, and the PVC
will remain in pending state. StorageOS never received the action to perform,
so it never sent back an acknowledgement.

The StorageClass provisioned for StorageOS references a Secret from where it
retrieves the API endpoint and the authentication parameters. If that secret is
incorrect or missing, the connections won't be established. It is common to see
that the Secret has been deployed in a different namespace where the
StorageClass expects it or that is has been deployed with a different name.

### Assert:

1. Check the StorageClass parameters to know where the Secret is expected to be found. 

    ```bash
    {{ page.cmd }} get storageclass fast -o yaml
    apiVersion: storage.k8s.io/v1
    kind: StorageClass
    metadata:
      creationTimestamp: 2018-09-25T08:44:57Z
      labels:
        app: storageos
      name: fast
      resourceVersion: "108853"
      selfLink: /apis/storage.k8s.io/v1/storageclasses/fast
      uid: 48490a9b-c09f-11e8-ba01-0800278dc04d
    parameters:
      adminSecretName: storageos-api
      adminSecretNamespace: storageos
      description: Kubernetes volume
      fsType: ext4
      pool: default
    provisioner: kubernetes.io/storageos
    reclaimPolicy: Delete
    ```

    > Note that the parameters specify `adminSecretName` and `adminSecretNamespace`. 

1. Check if the secret exists according to those parameters
    ```bash
    {{ page.cmd }} -n storageos get secret storageos-api
    No resources found.
    Error from server (NotFound): secrets "storageos-api" not found
    ```

    If no resources are found, it is clear that the Secret doesn't exist or it is not deployed in
    the right location. 

### Solution:
Deploy StorageOS following the [installation procedures]({%link
_docs/introduction/quickstart.md %}). If you are using the manifests provided
for {{ page.platform }} to deploy StorageOS rather than using automated
provisioners, make sure that the StorageClass parameters and the Secret
reference match.

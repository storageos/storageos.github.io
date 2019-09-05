## Upgrade StorageOS operator from yaml manifest


Upgrade the StorageOS operator using the following yaml manifest.

```
kubectl apply -f https://github.com/storageos/cluster-operator/releases/download/{{ site.latest_operator_version}}/storageos-operator.yaml
```

>  When you run the above command StorageOS Operator resources will be updated.
>  Since, the Update Strategy of the StorageOS Operator Deployment is set to
>  rolling update, a new StorageOS Operator Pod will be created. Only when
>  the new Pod enters the Running Phase will the old Pod be deleted.
>  Your StorageOS Cluster will not be affected while the StorageOS
>  Operator is upgrading.
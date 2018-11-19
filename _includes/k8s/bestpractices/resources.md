## Resource reservations

StorageOS resource consumption depends on the workloads and the StorageOS
features in use. 

For production environments, it is recommended to test StorageOS under
realistic workloads and tune resources accordingly.

The recommended minimum memory reservation for the StorageOS Pods is 235Mb.
However it is recommended to prepare nodes so StorageOS can operate at least
with 1-2GB of memory. StorageOS frees memory when possible.

StorageOS Pods resource allocation will impact directly on the availability of
the volumes in case of eviction or limit triggered restart. It is recommended
to not limit StorageOS Pods.

StorageOS implements a storage engine, therefore limiting CPU consumption might
affect the I/O throughput of your volumes.


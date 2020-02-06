The StorageOS CSI helper needs to mount a CSI Socket into the container so
on each node add the `svirt_sandbox_file_t` flag to the CSI socket directory
and CSI socket.

   ```bash
    chcon -Rt svirt_sandbox_file_t /var/lib/kubelet/plugins_registry/storageos
    ```

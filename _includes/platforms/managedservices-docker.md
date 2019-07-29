## Docker

Some managed Kubernetes platforms enable the 'Live-Restore' Docker feature,
enabling containers to continue running while Docker is stopped or upgraded.
This feature can cause nodes to hang while shutting-down or rebooting, as
rather than going through an orderly shutdown, StorageOS (and other processes)
are killed before the disks are synced and unmounted.  Devices in this
inaccessible state will log a warning similar to:

    Transport endpoint not connected

To prevent this behaviour, we advise disabling this feature by setting

    {
        ...
        "live-restore": false
    }

in `/etc/docker/daemon.json`.

Here's an example Ansible snippet that might achieve this

    ...
    - name: configure /etc/docker/daemon.json
      lineinfile:
          path: /etc/docker/daemon.json
          regexp: '^.*"live-restore": true,$'
          line: '  "live-restore": false,'
          backrefs: yes
      notify: restart docker
    ...

> Note: Use at own risk; you may need to adapt the example to work in your
> environment

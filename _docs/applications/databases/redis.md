---
layout: guide
title: StorageOS Docs - Redis
anchor: applications
module: applications/databases/redis
# Last reviewed by julian.topley@storageos.com on 2017-05-22
---

# ![image](/images/docs/explore/redislogo.png) Redis with StorageOS

Redis is a popular networked, in-memory, key-value data store with optional
durability to disk.

## Redis and StorageOS

Before you start, ensure you have StorageOS installed and ready on a Linux
cluster - please refer to the [quick start]({% link _docs/install/quickstart.md %})
guide for further details.

## Create a Redis Volume

1. Create a 1GB volume called `redis-data` in the default namespace.

   ```bash
   $ docker volume create --driver storageos --opt size=1 redis-data
   redis-data
   $ docker volume list
   DRIVER              VOLUME NAME
   storageos:latest    redis-data
   ```

1. Run a Redis container using the StorageOS volume driver.

   ```bash
   docker run -d --name redis-test -v redis-data:/data --volume-driver=storageos redis redis-server --appendonly yes --tcp-backlog 128
   ```

   * Using `--appendonly yes` with a volume mount starts Redis in persistent
     mode.
   * Using `--tcp-backlog 128` resolves a Redis TCP backlog warning as it
     attempts to use 511.
   * This image includes EXPOSE 6379 (the redis port), making it automatically
     available to linked containers.

1. Confirm there are no errors or warnings.

   ```bash
   $ docker logs redis-test
   1:C 24 Aug 14:37:44.565 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
   1:C 24 Aug 14:37:44.565 # Redis version=4.0.1, bits=64, commit=00000000, modified=0, pid=1, just started
   1:C 24 Aug 14:37:44.565 # Configuration loaded
   1:M 24 Aug 14:37:44.566 * Running mode=standalone, port=6379.
   1:M 24 Aug 14:37:44.566 # Server initialized
   1:M 24 Aug 14:37:44.567 * Ready to accept connections
   ```

   Refer to the Configuration section below for more details on warning messages.

## Link to redis-benchmark Container

1. Link redis-benchmark.

   ```bash
   docker run -it --rm --link redis-test:redis clue/redis-benchmark
   ====== PING_INLINE ======
     100000 requests completed in 1.89 seconds
     50 parallel clients
     3 bytes payload
     keep alive: 1

   97.34% <= 1 milliseconds
   99.96% <= 2 milliseconds
   100.00% <= 2 milliseconds
   52994.17 requests per second

   ====== PING_BULK ======
     100000 requests completed in 2.03 seconds
   ...
   ```

## Configuration

1. For more details on configuring and linking this container image please visit
   the  [Redis Docker Hub Repository](https://hub.docker.com/_/redis/).
1. For more information about managing persistence with Redis, see
   [Redis Persistence](https://redis.io/topics/persistence/).
1. Depending on the host Linux system configuration there may be additional
   system settings that need to be applied - refer to the docker logs for more
   details.

* The following warning refers to the container itself:

   ```bash
   WARNING: The TCP backlog setting of 511 cannot be enforced because /proc/sys/net/core/somaxconn is set to the lower value of 128.
   ```

   Increasing the TCP backlog setting needs to be done from the container
   (increase the value for `/proc/sys/net/core/somaxconn`), alternatively add
   `--tcp-backlog 128` to the end of the Docker command line if this is
   sufficient.

* The following two warnings apply to the host system the container is running
  on:

   ```bash
   WARNING overcommit_memory is set to 0! Background save may fail under low memory condition. To fix this issue add 'vm.overcommit_memory = 1' to /etc/sysctl.conf and then reboot or run the command 'sysctl vm.overcommit_memory=1' for this to take effect.
   ```

   ```bash
   WARNING you have Transparent Huge Pages (THP) support enabled in your kernel. This will create latency and memory usage issues with Redis. To fix this issue run the command 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' as root, and add it to your /etc/rc.local in order to retain the setting after a reboot. Redis must be restarted after THP is disabled.
   ```

   These can be resolved by adding the following lines to`/etc/rc.local` on the
   host and restarting:

   ```bash
   echo never | sudo tee /sys/kernel/mm/transparent_hugepage/enabled
   sudo sysctl vm.overcommit_memory=1
   ```

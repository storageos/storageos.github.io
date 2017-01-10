---
layout: guide
title: Docker integration
anchor: reference
module: 6-reference/docker
---

# StorageOS Docker Volume Plugin

## Installation

Build from source (see [Building](#Building)) or download binary (TBA)

Copy to `/usr/local/bin`.

Make executable: `chmod +x /usr/local/bin/storageos-docker-plugin`

## Start Server
The plugin runs as a standalone server that accepts HTTP requests from the Docker daemon.

Make sure `/etc/docker/plugins/storageos.json` is present on the Docker host then start:

```
$ sudo /usr/local/bin/storageos-docker-plugin server
```

## Configuration

There are two configuration steps.

### Docker

Firstly, the Docker daemon needs to know to look for the plugin.  It checks for configuration files in `/etc/docker/plugins/storageos.json` and `/usr/lib/docker/plugins/storageos.json`

Create `/etc/docker/plugins/storageos.json` with contents:

```javascript
{
  "Name": "storageos",
  "Addr": "http://localhost:5705/"
}
```

### Plugin

Secondly, the plugin may require configuration if the defaults need to be modified.  Currently the defaults should work.

Config may be changed with command-line flags or with a config file.

Running the plugin with `help` gives more info:

```
$ /usr/local/bin/storageos-docker-plugin help

StorageOS volume driver for Docker, providing persistent storage to
Docker containers using the StorageOS distributed storage technology.

Usage:
  storageos-docker-plugin [command]

Available Commands:
  config      Print the plugin configuration
  server      Starts the StorageOS plugin

Flags:
      --config string       config file (default is /etc/storageos.yaml)
      --log-format string   specify output (text or json) (default "text")
      --log-level string    one of debug, info, warn, error, or fatal (default "info")

Use "storageos-docker-plugin [command] --help" for more information about a command.
```

## Building

[Dapper](https://github.com/rancher/dapper) is used for compiling the plugin in a known environment.  A simple Makefile initiates the build:

```
$ make build
```

This produces a statically-linked linux binary named `storageos-docker-plugin` in the source directory.  This file should be copied into `/usr/local/bin` and made executable.

## Usage

Try to start a container with a volume using the StorageOS plugin:

```
$ sudo docker run -d --name redis-test -v dev-docker-redis01:/data --volume-driver=storageos redis redis-server --appendonly yes
```

Or, try to pre-provision a volume:

```
$ sudo docker volume create --name dev-docker-redis01 --driver storageos --opt size=20
```

If successful, you should see the volume with `docker volume ls`:

```
# docker volume ls
DRIVER              VOLUME NAME
storageos           dev-docker-redis01
```

Benchmark:

```
$ sudo docker run -it --rm --link redis-test:redis clue/redis-benchmark
```

There should also be a corresponding volume in `/storageos`

## Troubleshooting

There are few relevant logs to tail when troubleshooting.

#### Plugin

Currently this is just the standard output from the process.

#### Docker

```
$ sudo journalctl -u docker -f
```

#### Control plane

```
$ storageos logs control
```

#### Data plane

```
$ sudo journalctl -u dataplane -f
```



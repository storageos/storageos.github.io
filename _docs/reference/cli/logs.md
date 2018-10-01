---
layout: guide
title: StorageOS Docs - Logs
anchor: reference
module: reference/cli/logs
---

# Logs

```bash
Usage:	storageos logs COMMAND

View and manage node logs

Options:
      --clear-filter       Clears the filter
      --filter string      Set the logging filter
  -f, --follow             Tail the logs for the given node, or all nodes if not specified
      --format string      Output format (raw or table) or a Go template (default "raw")
      --help               Print usage
   -l, --log-level string   Set the logging level ("debug"|"info"|"warn"|"error"|"fatal")
  -q, --quiet              Only display volume names
  -t, --timeout int        Timeout in seconds. (default 5)

Commands:
  view        Show logging configuration

Run 'storageos logs COMMAND --help' for more information on a command.
```

The `logs` command is intended to assist with troubleshooting a running cluster.

`--log-level` controls the level of detail shown in the logs with `info` the
default.  The available options are `debug`, `info`, `warn`, `error` and
`fatal`.  During normal operation `info` level is recommended.

Filters fine-tune the amount of detail shown.  They allow you to set the log
level to `debug` level, then set specific categories at a higher level
(e.g. `info`) so there is less noise while troubleshooting an issue.

For example, the filter `dp=info,cp=info,etcd=debug` would set all dataplane and
controlplane categories to `info` level, then only enable `debug` on the `etcd`
category.  Filters are evaluated from left to right.  The log level must also be
set to `debug` to show the `etcd` category at `debug` level.

Categories are tags on log messages that relate to the component that generated
them.  A typical log message looks like:

```
time="2018-01-11T12:42:58Z" level=info msg="lost leadership election, waiting" action=election category=leader error="already exists" module=ha
```

### `storageos logs view`

Displays the current log levels and filters for the whole cluster.

```bash
storageos logs view
NODE         LEVEL  FILTER
storageos-1  debug  cp=info,dp=info,leader=debug
storageos-2  info
storageos-3  debug  cp=info,dp=info,ha=debug
```

### Set log verbosity

To set the log level on all nodes in the cluster:

```bash
storageos logs --log-level debug
OK
```

To set the log level on specific nodes, append a list of node names:

```bash
storageos logs --log-level debug storageos-1 storageos-2
OK
```

### Set filter

To set a filter on a single node:

```bash
storageos logs --filter cp=info,dp=info,leader=debug storageos-1
OK
```

If no node names are given, the filter will be applied to all nodes.

### Clear filter

To remove the filter, use the `--clear-filter` flag.

To clear on all nodes:

```bash
storageos logs --clear-filter
OK
```

You can clear the filter on specific nodes by appending one or more node names:

```bash
storageos logs --clear-filter storageos-1
OK
```

### Viewing logs

`--follow` flag allows you to view the cluster logs as they are generated.

```bash
# Tail logs for the given node
storageos logs --follow storageos-1

# Tail log for all nodes
storageos logs --follow
```

---
layout: guide
title: StorageOS Docs - Login
anchor: reference
module: reference/cli/login
---

# Login

(Download and install the StorageOS CLI [here]({%link _docs/reference/cli/index.md %})

```bash
$ storageos login --help

Usage:	storageos login [HOST]

Store login credentials for a given storageos host

Options:
      --help              Print usage
      --password string   The password to use for this host
      --username string   The username to use for this host
```

The storageos CLI provides a simple credentials helper to aid in cluster management.
In addition to the use of environment variables `STORAGEOS_USERNAME` and `STORAGEOS_PASSWORD` the credentials stored by this command are available for use to authenticate with a cluster.
The CLI will automatically use the stored credentials when contacting a known host (if not overridden by `-u` or `-p`).

To store credentials for a host use the `login` command:

```bash
$ storageos login 10.1.5.249
Username: storageos
Password: 
Credentials verified
```

These credentials are then stored in the file `$HOMEDIR/.storageos/config.json`

```json
{
	"knownHosts": {
		"10.1.5.249:5705": {
			"username": "storageos",
			"password": "c3RvcmFnZW9z"
		}
	}
}
```

On Windows and Linux these credentials are stored in plain-text equivalent base-64 so users should take appropriate measures to protect the contents of this file.
On the Mac platform, osx-keychain integration is provided, enabling secure credential storage.

```json
{
	"knownHosts": {
		"10.1.5.249:5705": {
			"username": "storageos",
			"useKeychain": true
		}
	}
}
```

## Copying credentials between machines

On Windows and Linux, migrating credentials to another machine is simple. Just copy the file `$HOMEDIR/.storageos/config.json` to the same path on the new machine.

For Mac machines, the contents stored in the keychain must also be copied. Information on how to do this can be found on [Apple's site](https://support.apple.com/kb/PH20120?locale=en_US).
For user convenience, all credentials stored in the keychain by the storageos CLI will use the service name `storageos_cli`.

# Logout

Once credentials for a cluster are no-longer needed, use the logout command to forget the credentials.

```bash
$ storageos logout 10.1.5.249
```

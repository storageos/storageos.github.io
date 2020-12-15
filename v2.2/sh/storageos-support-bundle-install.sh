#!/bin/bash

# Create a temporary directory in which to store the plugin binaries
TMP_DIR=$(mktemp -d /tmp/storageos-kubectl-plugin-XXXXX)

# Download the plugin binaries and extract to the temporary directory
TARGET="kubectl-storageos.tar.gz"
curl -sSL -o kubectl-storageos.tar.gz https://github.com/storageos/storageos.github.io/raw/master/sh/$TARGET
tar -xf kubectl-storageos.tar.gz -C $TMP_DIR/

# Clean up the zip file
rm -f kubectl-storageos.tar.gz

# Add executable permissions for the plugin binaries and move into system path
chmod +x $TMP_DIR/bin/kubectl-storageos-bundle
sudo mv $TMP_DIR/bin/kubectl-storageos-bundle /usr/local/bin/
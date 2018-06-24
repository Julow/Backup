#!/bin/bash

# Go to the script's directory
cd ${0%/*}
PATH="$(pwd):$PATH"

# The folder that contains backup datas
BACKUP_LOCATION=$(pwd)/backup

mkdir -p "$BACKUP_LOCATION"
cd "$BACKUP_LOCATION"

# Sync
sync_github.sh "Julow"
sync_user.sh ~/.presets ~/Documents/config

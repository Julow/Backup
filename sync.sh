#!/bin/bash
cd ${0%/*}

# -
# Configs

# The folder that contains backup datas
BACKUP_LOCATION=$(pwd)/backup

# Commands to run
# They are run in the $BACKUP_LOCATION directory
# sync_* scripts are available
sync ()
{
	sync_github.sh "Julow"
	sync_user.sh ~/.presets ~/Documents/config
}

# End of configs
# -

name_noclash ()
{
	NAME="$1$2"
	i=1
	while [[ -e "$NAME" ]]
	do
		NAME="$1-$i$2"
		(( i++ ))
	done
	echo "$NAME"
}

# Sync
PATH="$(pwd):$PATH"
mkdir -p "$BACKUP_LOCATION"
( cd "$BACKUP_LOCATION"; sync )

# Build the archive
BACKUP_NAME=$(name_noclash "backup-$(date +"%F")" ".tar.gz")
tar -czf "$BACKUP_NAME" -C "$BACKUP_LOCATION" .

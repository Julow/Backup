#!/bin/bash
cd ${0%/*}

# -
# Configs

BACKUP_ROOT="$(pwd)"

# The folder that contains backup datas
BACKUP_LOCATION="$BACKUP_ROOT/backup"

# Usage: ```( in_directory "path"; command )```
in_directory ()
{
	mkdir -p "$1"
	cd "$1"
}

# Commands to run
# They are run in the $BACKUP_LOCATION directory
# sync_* scripts are available
# The sync_* scripts take absolute paths
sync ()
{
	sync_github.sh "Julow"
	sync_user.sh "$BACKUP_ROOT/sync.sh"
	( in_directory projects; sync_git.sh ~/Documents/projects/* )
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
( in_directory "$BACKUP_LOCATION"; sync )

# Build the archive
BACKUP_NAME=$(name_noclash "backup-$(date +"%F")" ".tar.gz")
echo "# Archive: $BACKUP_NAME"
tar -czf "$BACKUP_NAME" -C "$BACKUP_LOCATION" .

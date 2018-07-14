#!/bin/bash
set -e

# Backup git repositories

for uri in "$@"
do
	DST=${uri##*/}
	DST=${DST%%.git}
	echo "$uri -> $DST"
	if [[ -d $DST ]]; then
		# Already cloned, just update
		( cd "$DST"; git remote update )
	else
		mkdir -p "$DST"
		git clone --mirror -q --progress -- "$uri" "$DST"
	fi
done

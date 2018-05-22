#!/bin/bash

source config.sh

# Call every sync.sh scripts
# On error, save stdout and stderr to /tmp

tmp="/tmp/sync_$(date +"%s")__tmp"
mkdir -p "$tmp"

for sync in */sync.sh; do
	d=${sync%/*}
	echo " => $d"
	(	cd "$d"
		bash -e "${sync##*/}" ) > >(tee "$tmp/out") 2> >(tee "$tmp/err")
	case $? in
		0) ;;
		1)		saved="${tmp%__tmp}_${d}"
				echo "An error occurred while syncing. Saved to $saved"
				cp -r "$tmp" "$saved" ;;
		101)	echo "Not configured" ;;
	esac
done

rm -rf "$tmp"

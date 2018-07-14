#!/bin/bash

# Backup git repositories
# For local repositories, backups staged, unstaged and untracked files

untracked_changes ()
{
	if [[ -e .gitignore ]]
	then IGNORE="-X .gitignore"
	else IGNORE=""
	fi
	for f in $(git ls-files -o $IGNORE)
	do
		if [[ -d $f ]]
		then echo "Warning: $f: Untracked change cannot be backup" >&2
		else git diff --binary /dev/null "$f"
		fi
	done
}

update_patches ()
{
	if [[ -d "$1" ]]
	then
		DST=$(pwd)
		cd "$1"
		git diff --staged > "$DST/staged-changes.patch"
		git diff > "$DST/unstaged-changes.patch"
		untracked_changes > "$DST/untracked-changes.patch"
	fi
}

for uri in "$@"
do
	DST=${uri##*/}
	DST=${DST%%.git}
	echo "# [Git] $uri"
	if [[ -d $DST ]]; then
		# Already cloned, just update
		( cd "$DST"; git remote update >/dev/null; update_patches "$uri" )
	else
		mkdir -p "$DST"
		git clone --mirror -q --progress -- "$uri" "$DST"
		( cd "$DST"; update_patches "$uri" )
	fi
done

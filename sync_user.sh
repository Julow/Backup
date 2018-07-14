#!/bin/bash

# Backup custom files/folders

mkdir -p user
cd user

if ! [[ -d .git ]]; then git init; fi

for src in "$@"
do
	echo "# [User] $src"
	# Strip leading dot from the base name
	dst=${src##*/}
	dst=${dst##.}
	rm -rf -- "$dst"
	cp -r -- "$src" "$dst"
	if ! git diff --exit-code -- "$dst" > /dev/null
	then
		git add "$dst"
		git commit -q -m "$dst" "$dst"
	fi
done

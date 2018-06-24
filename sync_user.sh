#!/bin/bash

# Backup custom files/folders

mkdir -p user
cd user

if ! [[ -d .git ]]; then git init; fi

for src in "$@"
do
	# Strip leading dot from the base name
	dst=${src##*/}
	dst=${dst##.}
	rm -rf -- "$dst"
	cp -r -- "$src" "$dst"
	git add "$dst"
	git commit -m "$dst" "$dst"
done

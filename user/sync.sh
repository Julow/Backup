#!/bin/bash

# Backup custom files/folders

mkdir -p backup
cd backup

if ! [[ -d .git ]]; then git init; fi

for src in "$@"
do
	dst=${src##*/}
	rm -rf -- "$dst"
	cp -r -- "$src" "$dst"
	git add "$dst"
	git commit -m "$dst" "$dst"
done

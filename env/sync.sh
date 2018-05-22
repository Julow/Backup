#!/bin/bash

# Backup custom files/folders

for b in $LOCAL
do
	d=${b##*/}
	rm -rf -- "$d"
	cp -r -- "$b" "$d"
done

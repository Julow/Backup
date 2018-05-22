#!/bin/bash

# Backup every public repos for an user

USER=${GITHUB_USER?Variable not set}

# Empty USER, do nothing
if [[ -z $USER ]]; then exit 101; fi

# https://developer.github.com/v3/repos/#list-user-repositories
curl --silent "https://api.github.com/users/$USER/repos?type=all&per_page=10000" > repo_list

# Parsing JSON with sed haha
REPOS=`sed -nE 's/ *"full_name": "(.+)",/\1/p' repo_list`

for repo in $REPOS
do
	echo "$repo"
	if [[ -d $repo ]]; then
		# Already cloned, just update
		(	cd "$repo"
			git remote update )
	else
		mkdir -p "$repo"
		git clone --mirror -q --progress -- "git://github.com/$repo.git" "$repo"
	fi
done

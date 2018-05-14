#!/bin/bash

# Clone every public repos for an user

USER=${GITHUB_USER?Variable not set}

# Empty USER, do nothing
if [[ -z $USER ]]; then exit 1; fi

echo "Syncing..."

# https://developer.github.com/v3/repos/#list-user-repositories
curl --silent "https://api.github.com/users/$USER/repos?type=all&per_page=10000" > repo_list

# Parsing JSON with sed haha
REPOS=`sed -nE 's/ *"full_name": "(.+)",/\1/p' repo_list`

for repo in $REPOS
do
	echo "$repo"
	if [[ -d $repo ]]; then
		# Already cloned, just fetch
		(	cd "$repo"
			git fetch -q --all
			git pull -q --no-ff )
	else
		mkdir -p "$repo"
		git clone -q -- "git://github.com/$repo.git" "$repo"
	fi
done

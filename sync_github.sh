#!/bin/bash
set -e

# Backup every public repos for an user

USER=${1:?Missing argument: Github user}

mkdir -p github
cd github

echo "# [Github] $USER"

# https://developer.github.com/v3/repos/#list-user-repositories
curl --silent "https://api.github.com/users/$USER/repos?type=all&per_page=10000" > repo_list

# Parsing JSON with sed haha
REPOS=`sed -nE 's/ *"full_name": "(.+)",/\1/p' repo_list`

for repo in $REPOS
do
	USER=${repo%%/*}
	mkdir -p "$USER"
	( cd "$USER"; sync_git.sh "git://github.com/$repo.git" )
done

#!/bin/bash

set -o xtrace
set -e

source .env

type -p yum-config-manager >/dev/null || yum install yum-utils
yum-config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
yum install gh -y

echo $GH_TOKEN | gh auth login --with-token

app_dir=$(pwd)
temp_dir=$(mktemp -d)
echo "Creating temporary directory $temp_dir"
echo "Cloning $GITHUB_REPOSITORY at $GITHUB_SHA"
cd $temp_dir
git init
git remote add origin https://github.com/$GITHUB_REPOSITORY
git fetch origin $GITHUB_SHA
git checkout $GITHUB_SHA
git switch -c deploy_$GITHUB_SHA

echo "Copying files from $temp_dir to $app_dir"
cp -r $temp_dir/. $app_dir
cd $app_dir

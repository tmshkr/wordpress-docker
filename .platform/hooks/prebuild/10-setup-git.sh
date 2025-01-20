#!/bin/bash

set -o xtrace
set -e

source .env

echo "Setting up git"
git config --global user.email "$GITHUB_ACTOR@users.noreply.github.com"
git config --global user.name "$GITHUB_ACTOR"
echo
echo "Setting up SSH"
mkdir -p ~/.ssh
mv id_ed25519 >~/.ssh/id_ed25519
chmod 600 ~/.ssh/id_ed25519
ssh-keyscan -t rsa github.com >>~/.ssh/known_hosts
echo "Setting up git environment"
git config --global core.sshCommand "ssh -i ~/.ssh/id_ed25519"

app_dir=$(pwd)
temp_dir=$(mktemp -d)
echo "Creating temporary directory $temp_dir"
echo "Cloning $GITHUB_REPOSITORY at $GITHUB_SHA"
cd $temp_dir
git init
git remote add origin git@github.com:$GITHUB_REPOSITORY.git
git fetch origin $GITHUB_SHA
git checkout $GITHUB_SHA
git switch -c deploy_$GITHUB_SHA

echo "Copying files from $temp_dir to $app_dir"
cp -r $temp_dir/. $app_dir
cd $app_dir

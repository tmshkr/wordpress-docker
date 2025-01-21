#!/bin/bash

set -o xtrace
set -e

source .env

echo "Setting up git"
dnf update
dnf install git -y
git config --global user.email "$GITHUB_ACTOR@users.noreply.github.com"
git config --global user.name "$GITHUB_ACTOR"
ssh-keyscan -t rsa github.com >>~/.ssh/known_hosts
git config --global core.sshCommand "ssh -i ~/.ssh/id_ed25519"

app_dir=$(pwd)
temp_dir=$(mktemp -d)
echo "Creating temporary directory $temp_dir"
echo "Cloning $GITHUB_REPOSITORY at $GITHUB_SHA"
cd $temp_dir
git init
git remote add origin git@github.com:$GITHUB_REPOSITORY.git
git fetch origin $GITHUB_SHA
git checkout -b deploy_$GITHUB_SHA $GITHUB_SHA

echo "Copying files from $temp_dir to $app_dir"
cp -r $temp_dir/. $app_dir
cd $app_dir

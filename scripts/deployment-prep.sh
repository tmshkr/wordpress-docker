#!/bin/bash -e

if [[ -z $MYSQL_ROOT_PASSWORD ]]; then
    echo "MYSQL_ROOT_PASSWORD is required"
    exit 1
fi

if [[ -z $MYSQL_PASSWORD ]]; then
    echo "MYSQL_PASSWORD is required"
    exit 1
fi

if [[ -z $TAILSCALE_AUTH_KEY ]]; then
    echo "TAILSCALE_AUTH_KEY is required"
    exit 1
fi

echo "MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD" >>.env
echo "MYSQL_DATABASE=wordpress" >>.env
echo "MYSQL_USER=wordpress" >>.env
echo "MYSQL_PASSWORD=$MYSQL_PASSWORD" >>.env
echo "TAILSCALE_AUTH_KEY=$TAILSCALE_AUTH_KEY" >>.env
echo "WORDPRESS_DB_HOST=db" >>.env
echo "WORDPRESS_DB_USER=wordpress" >>.env
echo "WORDPRESS_DB_PASSWORD=$MYSQL_PASSWORD" >>.env
echo "WORDPRESS_DB_NAME=wordpress" >>.env

zip -r bundle.zip . -x '*.git*'

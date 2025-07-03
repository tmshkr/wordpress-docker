#!/bin/bash -e

CODESPACE_NAME=$(cat /workspaces/.codespaces/shared/environment-variables.json | jq -r '.CODESPACE_NAME')
CANONICAL_DOMAIN="$CODESPACE_NAME-443.app.github.dev"

# .env
echo "CANONICAL_DOMAIN=$CANONICAL_DOMAIN" >.env
echo "MYSQL_DATABASE=wordpress" >>.env
echo "MYSQL_PASSWORD=dev_password_only" >>.env
echo "MYSQL_ROOT_PASSWORD=dev_password_only" >>.env
echo "MYSQL_USER=wordpress" >>.env
echo "SERVER_NAME=\"localhost $CANONICAL_DOMAIN\"" >>.env
echo "STAGE=\"development\"" >>.env
echo "TLS_MODE=tls_selfsigned" >>.env
echo "WP_HOME=\"https://$CANONICAL_DOMAIN\"" >>.env
echo "WP_SITEURL=\"https://$CANONICAL_DOMAIN\"" >>.env

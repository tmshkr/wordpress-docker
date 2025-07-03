#!/bin/bash -e

CODESPACE_NAME=$(cat /workspaces/.codespaces/shared/environment-variables.json | jq -r '.CODESPACE_NAME')
WP_DOMAIN="$CODESPACE_NAME-443.app.github.dev"

# .env
echo "WP_DOMAIN=$WP_DOMAIN" >.env
echo "MYSQL_DATABASE=wordpress" >>.env
echo "MYSQL_PASSWORD=dev_password_only" >>.env
echo "MYSQL_ROOT_PASSWORD=dev_password_only" >>.env
echo "MYSQL_USER=wordpress" >>.env
echo "SERVER_NAME=\"localhost $WP_DOMAIN\"" >>.env
echo "STAGE=\"development\"" >>.env
echo "TLS_MODE=tls_selfsigned" >>.env
echo "WP_HOME=\"https://$WP_DOMAIN\"" >>.env
echo "WP_SITEURL=\"https://$WP_DOMAIN\"" >>.env

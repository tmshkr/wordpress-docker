#!/bin/bash -e

# Create an array of required environment variables
required_env_vars=(
    "EB_DEPLOY_PRIVATE_KEY"
    "GITHUB_ACTOR"
    "GITHUB_REPOSITORY"
    "GITHUB_SHA"
    "MYSQL_ROOT_PASSWORD"
    "MYSQL_PASSWORD"
    "SERVER_NAME"
    "TAILSCALE_AUTH_KEY"
    "TLS_AUTO_EMAIL"
)

# Iterate over the array of required environment variables
for env_var in "${required_env_vars[@]}"; do
    # Check if the environment variable is not set
    if [[ -z "${!env_var}" ]]; then
        # Print an error message
        echo "$env_var is required"
        # Exit the script with a non-zero status
        exit 1
    fi
done

# Caddy
echo "SERVER_NAME=\"$SERVER_NAME\"" >>caddy/.env
echo "TLS_MODE=tls_auto" >>caddy/.env
echo "TLS_AUTO_EMAIL=$TLS_AUTO_EMAIL" >>caddy/.env

# GitHub
echo $EB_DEPLOY_PRIVATE_KEY >id_ed25519
echo "GITHUB_ACTOR=$GITHUB_ACTOR" >>.env
echo "GITHUB_REPOSITORY=$GITHUB_REPOSITORY" >>.env
echo "GITHUB_SHA=$GITHUB_SHA" >>.env

# MariaDB
echo "MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD" >>.env
echo "MYSQL_DATABASE=wordpress" >>.env
echo "MYSQL_USER=wordpress" >>.env
echo "MYSQL_PASSWORD=$MYSQL_PASSWORD" >>.env

# Tailscale
echo "TAILSCALE_AUTH_KEY=$TAILSCALE_AUTH_KEY" >>.env

zip -r bundle.zip . -x '*.git*'

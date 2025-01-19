#!/bin/bash -e

# Create an array of required environment variables
required_env_vars=(
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
echo "SERVER_NAME=$SERVER_NAME" >>caddy/.env
echo "TLS_MODE=tls_auto" >>caddy/.env
echo "TLS_AUTO_EMAIL=$TLS_AUTO_EMAIL" >>caddy/.env

# MariaDB
echo "MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD" >>.env
echo "MYSQL_DATABASE=wordpress" >>.env
echo "MYSQL_USER=wordpress" >>.env
echo "MYSQL_PASSWORD=$MYSQL_PASSWORD" >>.env

# Tailscale
echo "TAILSCALE_AUTH_KEY=$TAILSCALE_AUTH_KEY" >>.env

zip -r bundle.zip . -x '*.git*'

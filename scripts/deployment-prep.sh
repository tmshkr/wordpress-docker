#!/bin/bash -e

# Create an array of required environment variables
required_env_vars=(
    "HTTPS_CERTIFICATE"
    "HTTPS_PRIVATE_KEY"
    "SERVER_NAME"
    "MYSQL_ROOT_PASSWORD"
    "MYSQL_PASSWORD"
    "TAILSCALE_AUTH_KEY"
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

# nginx
echo "$HTTPS_CERTIFICATE" >nginx/certificate.crt
echo "$HTTPS_PRIVATE_KEY" >nginx/private.key

# MariaDB
echo "MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD" >>.env
echo "MYSQL_DATABASE=wordpress" >>.env
echo "MYSQL_USER=wordpress" >>.env
echo "MYSQL_PASSWORD=$MYSQL_PASSWORD" >>.env

# Tailscale
echo "TAILSCALE_AUTH_KEY=$TAILSCALE_AUTH_KEY" >>.env

# Wordpress
echo "WORDPRESS_DB_HOST=db" >>.env
echo "WORDPRESS_DB_USER=wordpress" >>.env
echo "WORDPRESS_DB_PASSWORD=$MYSQL_PASSWORD" >>.env
echo "WORDPRESS_DB_NAME=wordpress" >>.env

zip -r bundle.zip . -x '*.git*'

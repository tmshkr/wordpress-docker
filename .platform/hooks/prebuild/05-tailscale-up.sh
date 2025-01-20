#!/bin/bash

set -o xtrace
set -e

source .env

curl -fsSL https://tailscale.com/install.sh | sh && sudo tailscale up --auth-key=$TAILSCALE_AUTH_KEY

#!/bin/bash

set -o xtrace
set -e

curl -fsSL https://tailscale.com/install.sh | sh && sudo tailscale up --auth-key=

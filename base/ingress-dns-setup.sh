#!/usr/bin/env bash

# Sets up DNS resolution with Minikube. Currently only works on macOS.

set -e

BASE_DIR=$(dirname $0)
DOMAIN=$(yq eval '.environments.default.values[].y8s.domain' $BASE_DIR/helmfile.yaml)
MINIKUBE_IP=$(minikube ip)
RESOLVER_FILE="/etc/resolver/y8s-resolver"
TEMPFILE=$(mktemp)

cat <<- EOF > $TEMPFILE
domain ${DOMAIN}
nameserver ${MINIKUBE_IP}
search_order 1
timeout 5
EOF

echo "👋 need sudo to write the resolver file. this is optional, but can't be done by a regular user."
echo "   if you choose not to let this script sudo, control-c and run the copy command output below:"
echo ""
set -x
sudo cp $TEMPFILE $RESOLVER_FILE
rm $TEMPFILE

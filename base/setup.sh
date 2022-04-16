#!/usr/bin/env bash

# Enables Minikube addons, installs packages via `asdf` and installs required helm plugin for helmfile

BASE_DIR=$(dirname $0)

set -e

minikube addons enable ingress
minikube addons enable ingress-dns

asdf install

set +e

helm plugin list | grep '^diff' > /dev/null
if [[ $? -ne 0 ]] ; then
    echo "installing helm diff"
    helm plugin install https://github.com/databus23/helm-diff > /dev/null
fi

test -f $BASE_DIR/env-override.yaml || echo -e "---\ny8s: {}" > $BASE_DIR/env-override.yaml

GOSS_USE_ALPHA=1 goss --gossfile test/pre-check.yml validate

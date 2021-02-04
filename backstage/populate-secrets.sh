#!/usr/bin/env bash

# This'll be fixed when converting to Helm

DIR=`dirname $0`

. "${DIR}/../.env"

if [ -z "$GITHUB_TOKEN" ] || \
   [ -z "$GITHUB_CLIENT_ID" ] || \
   [ -z "$GITHUB_CLIENT_SECRET" ]; then
  echo "Environment vars GITHUB_TOKEN, GITHUB_CLIENT_ID, and GITHUB_CLIENT_SECRET all need to be exported in .env"
  exit 1
fi

kubectl create secret generic github -n backstage \
  --from-literal=client_id=${GITHUB_CLIENT_ID} \
  --from-literal=client_secret=${GITHUB_CLIENT_SECRET} \
  --from-literal=github_token=${GITHUB_TOKEN}

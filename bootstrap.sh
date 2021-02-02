#/bin/env bash

for CMD in kubectl microk8s.kubectl
do
  if command -v ${CMD} > /dev/null; then
    KUBECTL="${CMD}"
  fi
done

if [ -z $KUBECTL ]; then
  exit 1
fi

ACTION="apply"

if [ "${1}" = "delete" ]; then
  ACTION="delete"
fi

DIR=`dirname $0`

for FILE in ${DIR}/platform-services/*.yaml; do
  $KUBECTL $ACTION -f $FILE
done
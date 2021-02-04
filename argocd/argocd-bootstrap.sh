#!/usr/bin/env bash

# Doing this as a standalone bootstrap because the quick start wants to pull their manifest from latest, and we only need minor patches

if [ "$1" = "delete" ]; then
  for app in $(argocd app list -o name); do argocd app delete $app; done
  kubectl delete namespace argocd
  exit 0
fi

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# apply any overrides in argo-patch.yaml
kubectl patch svc argocd-server -n argocd --type merge --patch "$(cat argo-patch.yaml)"

export ARGOCD_PASS=$(kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2)
export ARGOCD_LOGIN="argocd login localhost:8443 --insecure --username admin --password ${ARGOCD_PASS}"
echo
echo "ArgoCD should be up and running shortly at https://localhost:8443"
echo "Login with username 'admin' and password '${ARGOCD_PASS}'"
echo

# waits until rollout of argocd-server is complete
kubectl rollout status -n argocd deployment.apps/argocd-server

if [ -x "$(command -v argocd)" ]; then
  $ARGOCD_LOGIN
else
  echo
  echo "Argocd cli not detected in path. Install it using instructions here and then login with:"
  echo "$ARGOCD_LOGIN"
  echo
fi

echo "create a demo app"
argocd repo add --username wyattwalter --password ${GITHUB_TOKEN} https://github.com/wyattwalter/demo-apps.git
argocd app create case-api --repo https://github.com/wyattwalter/demo-apps.git --path case-api --dest-namespace default --dest-server https://kubernetes.default.svc

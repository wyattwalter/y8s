#!/usr/bin/env bash

# Doing this as a standalone bootstrap because the quick start wants to pull their manifest from latest, and we only need minor patches

if [ "$1" = "delete" ]; then
  echo "Deleting apps in ArgoCD.."
  for app in $(argocd app list -o name); do argocd app delete $app; done
  echo "Sleeping to give time for ArgoCD to delete apps before deleting ArgoCD itself. There's no error checking or handling here, so check `kubectl get namespaces` for anything suspicious after this is done."
  sleep 60
  kubectl delete namespace argocd
  exit 0
fi

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# apply any overrides in argo-patch.yaml
kubectl patch svc argocd-server -n argocd --type merge --patch "$(cat argocd/argocd-patch.yaml)"
# apply local configs to argocd
kubectl apply -f argocd/argocd-config.yaml

export ARGOCD_PASS=$(kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2)
echo
echo "ArgoCD should be up and running shortly at https://localhost:8443"
echo "Initial login info: username: 'admin' and password: '${ARGOCD_PASS}'"
echo "We'll attempt change that in the moment, but if it fails you can use this ^^"
echo

# waits until rollout of argocd-server is complete
kubectl rollout status -n argocd deployment.apps/argocd-server

if [ -x "$(command -v argocd)" ]; then
  argocd login localhost:8443 --insecure --username admin --password ${ARGOCD_PASS}
  echo "argocd logged in, changing password"
  argocd account update-password --current-password ${ARGOCD_PASS} --new-password sekret

  echo "create some stuff and things"
  argocd repo add https://github.com/wyattwalter/y8s.git
  argocd app create apps --repo https://github.com/wyattwalter/y8s.git --path apps --dest-server https://kubernetes.default.svc

  argocd app sync apps >> bootstrap.log
  argocd app sync -l app.kubernetes.io/instance=apps >> bootstrap.log

  if [ -n $BROWSER ]; then
    echo "Launching a browser for ArgoCD. Bypass the self-signed certificate warning and you should be able to login with username 'admin' and password 'sekret'."
    $BROWSER 'https://localhost:8443/'
  fi
else
  echo
  echo "ArgoCD cli not detected in path. Install it and then run bootstrap again to finish the setup. Instructions here: https://argoproj.github.io/argo-cd/cli_installation/"
  echo
fi

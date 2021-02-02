#/bin/env bash

# Doing this as a standalone bootstrap because the quick start wants to pull their manifest from latest, and we only need minor patches

if [ "$1" = "delete" ]; then
  kubectl delete namespace argocd
  exit 0
fi

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# apply any overrides in argo-patch.yaml
kubectl patch svc argocd-server -n argocd --type merge --patch "$(cat argo-patch.yaml)"


kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2

sleep 5

ARGOCD_PASS=$(kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2)

echo "ArgoCD should be up and running shortly at https://localhost:8443"
echo "Login with username 'admin' and password '${ARGOCD_PASS}'"

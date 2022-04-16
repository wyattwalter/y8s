# y8s

k8s for y@. A demo platform.

## Tools you need to install

- [minikube](https://minikube.sigs.k8s.io/docs/start/)
- [asdf](https://asdf-vm.com/guide/getting-started.html)
- [1Password Secrets Automation](https://1password.com/products/secrets/) (via the 1Password Operator)

## Setup

y8s uses the 1Password operator to pull secrets into the cluster. Ideally this is the only secret value that you need to provide during bootstrap, but it does take a little bit of setup. Setup "Secrets Automation" at https://my.1password.com/integrations/active. Once that is provisioned, set the 1Password token and credentials JSON values into the example from env-example, saving the file as `.env`.

Bootstrap the system with:

```shell
minikube start --driver=hyperkit --memory=6g
make # enables needed plugins in minikube, installs tools via `asdf`
make install # installs ArgoCD and bootstraps the services for the cluster
```

If successful, it'll start up an ArgoCD instance which will bootstrap the rest of the apps included in this repo. 

Tear it all down with:

```shell
make uninstall
sudo rm /etc/resolver/y8s-resolver # only if you setup ingress-dns on mac
minikube delete # optional
```

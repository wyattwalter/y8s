# y8s

k8s for y@. A demo platform.

## Tools you need to install

- [minikube](https://minikube.sigs.k8s.io/docs/start/)
- [asdf](https://asdf-vm.com/guide/getting-started.html)

## Setup

To get started, you'll need to register an OAuth application on GitHub (callback is localhost:7000 for now) and a GitHub personal access token. For the personal access token, it needs repo, workflow, and admin:repo_hook access.

Store those secrets into the .env file in your local checkout like:

```
export GITHUB_TOKEN=<token>
export AUTH_GITHUB_CLIENT_ID=<id>
export AUTH_GITHUB_CLIENT_SECRET=<secret>
```

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

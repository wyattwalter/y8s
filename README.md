# y8s

k8s for y@. A demo platform.

## Tools you need to install

- minikube
- minikube start --driver=hyperkit --memory=6g
- minikube addons enable ingress
- minikube addons enable ingress-dns
- asdf
- `asdf install`
- `helm plugin install https://github.com/databus23/helm-diff`

## Setup

To get started, you'll need to register an OAuth application on GitHub (callback is localhost:7000 for now) and a GitHub personal access token. For the personal access token, it needs repo, workflow, and admin:repo_hook access.

Store those secrets into the .env file in your local checkout like:

```
export GITHUB_TOKEN=<token>
export AUTH_GITHUB_CLIENT_ID=<id>
export AUTH_GITHUB_CLIENT_SECRET=<secret>
```

Bootstrap the system with:

```
./bootstrap.sh
```

If successful, it'll start up an ArgoCD instance which will bootstrap the rest of the apps included in this repo. In order to get Backstage to work, you'll need to also populate the secrets it's looking for. This process could be improved, but for now just run:

```
./backstage/populate-secrets.sh
```

Tear it down with:

```
./bootstrap.sh delete
```

# y8s

This is just a demo repo to bootstrap a local platform-ish thing. It uses ArgoCD as the base and bootstraps using the [app-of-apps pattern](https://argoproj.github.io/argo-cd/operator-manual/cluster-bootstrapping/). There's little to no error handling and is not meant to be re-usable at the moment.

## Tools you need to install

- kubectl and a working k8s cluster (I am using Docker Desktop with Kubernetes installed)
- ArgoCD command line tool

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

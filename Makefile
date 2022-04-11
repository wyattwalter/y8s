.DEFAULT_GOAL := setup

.PHONY: install
install:
	source .env && helmfile -f base/helmfile.yaml apply

.PHONY: setup
setup:
	./base/setup.sh

.PHONY: uninstall
uninstall:
	source .env && helmfile -f base/helmfile.yaml destroy
.DEFAULT_GOAL := help

deploy: ## Deploys our example app to S3
	@./bin/deploy.sh

.PHONY: help deploy

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

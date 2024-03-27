[![Docker build and push](https://github.com/Contoso-LRI/github-az-runner-docker/actions/workflows/docker-build-push.yaml/badge.svg)](https://github.com/Contoso-LRI/github-az-runner-docker/actions/workflows/docker-build-push.yaml)

# GitHub action runner image for Azure

This container image is used to deploy [self-hosted GitHub actions runner](https://docs.github.com/en/actions/hosting-your-own-runners) on [Azure Container Instances](https://azure.microsoft.com/en-us/products/container-instances/).

## Docker hub

The image is available on Docker Hub: [https://hub.docker.com/r/lrivallain/gh-az-runner](lrivallain/gh-az-runner:latest)

## Configure

The configuration of the runner is made through the following environment variables:

| Variable           | Description                      |
| ------------------ | -------------------------------- |
| GH_OWNER_URL       | GitHub owner or organization URL |
| GH_RUNNER_NAME     | GitHub runner name               |
| GH_RUNNER_TAG_NAME | GitHub runner tag name           |
| GH_TOKEN           | GitHub token to register runner  |


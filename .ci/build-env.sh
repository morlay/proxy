#!/bin/bash

set -eux;

TARGETARCH=${TARGETARCH:-"amd64"}
REPO=${REPO:-"istio/proxy"}

IMAGE_NAME=${REPO}-build-env
IMAGE_TAG=${IMAGE_TAG:-"devel"}

TAG=${IMAGE_NAME}:${IMAGE_TAG}-${TARGETARCH}

docker build --tag=${TAG} --file .ci/docker/build-env.Dockerfile .
docker push ${TAG}
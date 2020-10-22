#!/bin/bash

set -eux;

TARGETARCH=${TARGETARCH:-"amd64"}
REPO=${REPO:-"istio/proxy"}

IMAGE_NAME=${REPO}-istio-envoy
IMAGE_TAG=${IMAGE_TAG:-"devel"}

BUILD_IMAGE=${BUILD_IMAGE:-"${REPO}-build-env:devel-${TARGETARCH}"}

docker run -e=TEST_TMPDIR=/tmp/bazel -v=/tmp/bazel:/tmp/bazel -v=${PWD}:/go/src/proxy -w=/go/src/proxy ${BUILD_IMAGE} make build_envoy

cp ./bazel-bin/src/envoy/envoy ./envoy
chmod +x ./envoy

ISTIO_ENVOY_VERSION=$(./envoy --version | grep version | sed -e 's/.*version\: //g')

TAG=${IMAGE_NAME}:${IMAGE_TAG}-${TARGETARCH}

docker build --tag=${TAG} --build-arg=ISTIO_ENVOY_VERSION=${ISTIO_ENVOY_VERSION} --file .ci/docker/istio-envoy.Dockerfile .
docker push ${TAG}
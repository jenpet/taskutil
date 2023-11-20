#!/bin/sh
if  [ -z "${DOCKERFILE}" ] || [ -z "${IMAGE_NAME}" ]; then
    echo "Missing 'DOCKERFILE' or 'IMAGE_NAME' parameter. Exiting (1)."
    exit 1
fi

DOCKER_CONTEXT="${DOCKER_CONTEXT:-.}"

# ensure paths are absolute
DOCKERFILE=$(realpath "${DOCKERFILE}")
DOCKER_CONTEXT=$(realpath "${DOCKER_CONTEXT}")

# set build version to default value when not provided
if [ -z "${BUILD_VERSION}" ]; then
  BUILD_VERSION="0.0.0"
fi

BUILD_TAG="${IMAGE_NAME}:${BUILD_VERSION}"

# append build hash to build when provided
if [ -n "${BUILD_HASH}" ]; then
  BUILD_TAG="${BUILD_TAG}-${BUILD_HASH}"
fi

LOG="Building image with name '${IMAGE_NAME}', version '${BUILD_VERSION}' and hash '${BUILD_HASH}'"
LOG="${LOG} based on file '${DOCKERFILE}' using build tag '${BUILD_TAG}' and context '${DOCKER_CONTEXT}'..."
echo "${LOG}"

docker build \
  --build-arg="VERSION=${BUILD_VERSION}" \
  --build-arg="HASH=${BUILD_HASH}" \
  --no-cache \
  --progress plain \
  -t "${BUILD_TAG}" \
  -f "${DOCKERFILE}" \
  "${DOCKER_CONTEXT}"

if [ "${TAG_LATEST}" = true ]; then
  LATEST_TAG="${IMAGE_NAME}:latest"
  echo "Additionally tagging image with ${LATEST_TAG}..."
  docker tag "${BUILD_TAG}" "${LATEST_TAG}"
fi

echo "Done building image '${BUILD_TAG}'."
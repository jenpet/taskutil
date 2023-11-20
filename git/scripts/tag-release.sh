#!/bin/sh
if [ -z "${COMPONENT_NAME}" ] || [ -z "${VERSION_TAG}" ]; then
  echo "Missing 'COMPONENT_NAME' or 'VERSION_TAG' parameter. Exiting (1)."
  exit 1
fi

current_head_commit=$(git rev-parse HEAD)
head_tag=$(git tag --contains "${current_head_commit}" | grep -E "^\d+(\.\d+)?(\.\d+)?$")
if [ -n "$head_tag" ]; then
  echo "Current head commit '${current_head_commit}' already has the version tag '${head_tag}'."
  if [ "${CONFLICT_MODE}" != "override" ]; then
    echo "WARNING: 'CONFLICT_MODE' not set to 'override', aborting. Exiting(1)."
    exit 1
  fi
  echo "Replacing existing tag '${head_tag}'..."
  git tag -d "${head_tag}" > /dev/null
fi

RELEASE_MSG="${COMPONENT_NAME} release ${VERSION_TAG}"

git tag -a "${VERSION_TAG}" -m "${RELEASE_MSG}"
echo "Tagged HEAD commit (${current_head_commit}) with tag '${VERSION_TAG}' and message '${RELEASE_MSG}'"
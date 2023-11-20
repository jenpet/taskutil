#!/bin/sh
if [ -z "${REGISTRY}" ] || [ -z "${REGISTRY_USER}" ] || [ -z "${REGISTRY_PASSWORD}" ]; then
  echo "Missing parameter 'REGISTRY', 'REGISTRY_USER', or 'REGISTRY_PASSWORD'. Exiting (1)."
  exit 1
fi;

echo "Logging into registry '${REGISTRY}' with user '${REGISTRY_USER}' and password."
echo "${REGISTRY_PASSWORD}" | docker login -u "${REGISTRY_USER}" --password-stdin "${REGISTRY}"
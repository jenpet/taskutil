#!/bin/sh
if [ -z "${VOLUME}" ] || [ -z "${VPATH}" ] || [ -z "${LPATH}" ]; then
  echo "Missing 'VOLUME', 'VPATH' or 'LPATH' parameter. Exiting (1)."
  exit 1
fi

echo "Ensuring docker volume existence of volume '${VOLUME}'..."
docker volume create "${VOLUME}" >> /dev/null

HELPER_CONTAINER_NAME="${HELPER_CONTAINER_NAME:-"little-helper"}"

echo "Copying files from '${LPATH}' to '${VOLUME}:${VPATH}'..."
docker create --name="${HELPER_CONTAINER_NAME}" -v "${VOLUME}:/data/" busybox /bin/sh -c "ls -lash /data/${VPATH}" \
  && docker cp "${LPATH}" "${HELPER_CONTAINER_NAME}:/data/${VPATH}" \
  && docker start -a "${HELPER_CONTAINER_NAME}" \
  && docker rm "${HELPER_CONTAINER_NAME}" > /dev/null \
  && echo "Done copying."
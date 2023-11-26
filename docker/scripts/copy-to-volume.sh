#!/bin/sh
if [ -z "${VOLUME}" ] || [ -z "${VPATH}" ] || [ -z "${LPATH}" ]; then
  echo "Missing 'VOLUME', 'VPATH' or 'LPATH' parameter. Exiting (1)."
  exit 1
fi

echo "Ensuring docker volume existence of volume '${VOLUME}'..."
docker volume create "${VOLUME}" >> /dev/null

HELPER_CONTAINER_NAME="${HELPER_CONTAINER_NAME:-"little-helper"}"

echo "Copying files from '${LPATH}' to '${VOLUME}:${VPATH}'..."
docker run --name="${HELPER_CONTAINER_NAME}" -d -v "${VOLUME}:/data/" busybox sleep infinity > /dev/null \
  && docker cp "${LPATH}" "${HELPER_CONTAINER_NAME}:/data/${VPATH}"

if [ -n "${GROUP}" ]; then
  docker exec "${HELPER_CONTAINER_NAME}" /bin/sh -c "chgrp -R ${GROUP} /data/${VPATH}"
  echo "Set group to '${GROUP}'."
fi

if [ -n "${OWNER}" ]; then
  docker exec "${HELPER_CONTAINER_NAME}" /bin/sh -c "chown -R ${OWNER} /data/${VPATH}"
  echo "Set owner to '${OWNER}'."
fi

docker exec "${HELPER_CONTAINER_NAME}" /bin/sh -c "ls -lash /data/${VPATH}" \
  && docker rm "${HELPER_CONTAINER_NAME}" -f > /dev/null \
  && echo "Done copying."
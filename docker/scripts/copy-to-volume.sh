#!/bin/sh
if [ -z "${VOLUME}" ] || [ -z "${VPATH}" ] || [ -z "${LPATH}" ]; then
  echo "Missing 'VOLUME', 'VPATH' or 'lpath' parameter. Exiting (1)."
  exit 1
fi

echo "Ensuring docker volume existence of volume '${VOLUME}'..."
docker volume create "${VOLUME}" >> /dev/null

echo "Copying files from '${LPATH}' to '${VOLUME}:${VPATH}'..."
docker run --rm --name="${HELPER_CONTAINER_NAME:-"little-helper"}" -v "${VOLUME}:/dest" -v "${LPATH}:/src" \
  "${HELPER_IMAGE:-busybox}" /bin/sh -c "mkdir -p /dest/${VPATH} && cp -r /src/* /dest/${VPATH} \
  && ls -lash /dest/${VPATH}"
echo "Done copying."
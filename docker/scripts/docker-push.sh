#!/bin/sh
if [ -z "${IMAGE}" ]; then
  echo "Missing parameter 'IMAGE'. Exiting (1)."
  exit 1
fi;

echo "Pushing image '${IMAGE}'..."
docker push "${IMAGE}"
echo "Successfully pushed image."

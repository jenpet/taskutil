#!/bin/sh
if [ -z "${CURRENT_VERSION}" ]; then
  echo "Missing CURRENT_VERSION parameter following semver syntax <MAJOR>.<MINOR>.<PATCH>. Exiting (1)."
  exit 1
fi

if [ -z "${BUMP_METHOD}" ]; then
  BUMP_METHOD="minor"
fi

major=$(echo "${CURRENT_VERSION}" | awk -F. '{print $1}')
minor=$(echo "${CURRENT_VERSION}" | awk -F. '{print $2}')
patch=$(echo "${CURRENT_VERSION}" | awk -F. '{print $3}')

case "${BUMP_METHOD}" in
  major) major=$((major + 1)); minor=0; patch=0;;
  minor) minor=$((minor + 1)); patch=0;;
  patch) patch=$((patch + 1));;
  *) echo "Invalid BUMP_METHOD '${BUMP_METHOD}' use 'major', 'minor' or 'patch'. Exiting (1)."; exit 1
esac

part_count=$(echo "${CURRENT_VERSION}" | tr -cd '.' | wc -c)

version="${major}"

if [ "${part_count}" -ge 1 ]; then
  version="${version}.${minor}"
fi

if [ "${part_count}" -ge 2 ]; then
  version="${version}.${patch}"
fi

echo "${version}"
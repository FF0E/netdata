#!/bin/sh

set -e

FIRST_TAG="v1.47.0" # Last release prior to v2.0.0

SCRIPT_SOURCE="$(
    self=${0}
    while [ -L "${self}" ]
    do
        cd "${self%/*}" || exit 1
        self=$(readlink "${self}")
    done
    cd "${self%/*}" || exit 1
    echo "$(pwd -P)/${self##*/}"
)"

cd "$(dirname "${SCRIPT_SOURCE}")/.." || exit 1

# Check if the first tag exists, if not generate changelog from all commits
if git rev-parse "${FIRST_TAG}" >/dev/null 2>&1; then
    RANGE="${FIRST_TAG}..HEAD"
else
    echo "Tag ${FIRST_TAG} not found, generating changelog from all commits"
    RANGE=""
fi

git-cliff --config "$(dirname "${SCRIPT_SOURCE}")/cliff.toml" \
          --output "$(dirname "${SCRIPT_SOURCE}")/../CHANGELOG.md" \
          --verbose \
          ${RANGE}

#!/usr/bin/env bash

echo "${BASH_SOURCE[0]} $*"

BASH_PROFILE_DIR=$(dirname "${BASH_SOURCE[0]}")
BASH_PROFILE=${1:-${BASH_PROFILE:-default}}

case "${BASH_PROFILE}" in
  windows/mingw|mingw)
    DRIVES_PATH=/
    ;;
  windows/mobaxterm|mobaxterm)
    DRIVES_PATH=/drives
    ;;
  wsl/ubuntu)
    DRIVES_PATH=/mnt
    ;;
  default)
    ;;
  *)
    echo "Unsupported profile: '${BASH_PROFILE}'" >&2
    return 1
esac

source "${BASH_PROFILE_DIR}/aliases"
source "${BASH_PROFILE_DIR}/functions"

# Add features only for the available commands.
for feature in "${BASH_PROFILE_DIR}"/feature/*; do
  if command -v "$(basename "${feature}")" &> /dev/null; then
    # shellcheck source=/dev/null
    source "${feature}"
  fi
done

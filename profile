#!/usr/bin/env bash
# shellcheck disable=SC2034

echo "${BASH_SOURCE[0]} $*"

BASH_PROFILE_DIR=$(dirname "${BASH_SOURCE[0]}")
BASH_PROFILE=${1:-default}

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

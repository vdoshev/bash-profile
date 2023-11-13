#!/usr/bin/env bash
__start_time=$(date +%s%N)

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

source "${BASH_PROFILE_DIR}/functions"
source "${BASH_PROFILE_DIR}/aliases"

shift
# shellcheck disable=SC2086,SC2048
[ $# = 0 ] && set -- ${BASH_PROFILE_FEATURES[*]}
# shellcheck disable=SC2046
[ $# = 0 ] && set -- $(find "${BASH_PROFILE_DIR}/feature" -type f -printf "%f ")

BASH_PROFILE_FEATURES=()
for feature in "$@"; do
  # Add features only for the available commands.
  if command -v "${feature}" &> /dev/null; then
    # shellcheck source=/dev/null
    if source "${BASH_PROFILE_DIR}/feature/${feature}"; then
      BASH_PROFILE_FEATURES+=("${feature}")
    fi
  fi
done

__end_time=$(date +%s%N)
echo " ${BASH_PROFILE_FEATURES[*]} ($(( (__end_time - __start_time) / 1000000 )) ms)"
unset __start_time __end_time

#!/usr/bin/env bash
__start_time=$(date +%s%N)

BASH_PROFILE_DIR=$(dirname "${BASH_SOURCE[0]}")
BASH_PROFILE=${1:-${BASH_PROFILE:-default}}

cd "${BASH_PROFILE_DIR}" || return 1

case "${BASH_PROFILE}" in
  windows/mingw|mingw)
    DRIVES_PATH=/
    source profile.windows
    ;;
  windows/mobaxterm|mobaxterm)
    DRIVES_PATH=/drives
    source profile.windows
    ;;
  wsl/ubuntu)
    DRIVES_PATH=/mnt
    source profile.wsl
    ;;
  default)
    ;;
  *)
    echo "Unsupported profile: '${BASH_PROFILE}'" >&2
    return 2
esac

echo -n "${BASH_SOURCE[0]} ${BASH_PROFILE}"

source functions
source aliases

shift
# shellcheck disable=SC2086,SC2048
test $# -ne 0 || set -- ${BASH_PROFILE_FEATURES[*]}
# shellcheck disable=SC2046
test $# -ne 0 || set -- $(find feature -type f -printf "%f ")

BASH_PROFILE_FEATURES=()
for feature in "$@"; do
  # Add features only for the available commands.
  if command -v "${feature}" &> /dev/null; then
    # shellcheck source=/dev/null
    if source feature/"${feature}"; then
      BASH_PROFILE_FEATURES+=("${feature}")
    fi
  fi
done

__end_time=$(date +%s%N)
echo " ${BASH_PROFILE_FEATURES[*]} ($(( (__end_time - __start_time) / 1000000 )) ms)"
unset __start_time __end_time

#!/usr/bin/env bash
__start_time=$(date +%s%N)

BASH_PROFILE=${1:-${BASH_PROFILE:-default}}
BASH_PROFILE_DIR=$(dirname "${BASH_SOURCE[0]}")

cd "${BASH_PROFILE_DIR}" || return 1

case "${BASH_PROFILE}" in
  windows/mingw|mingw)
    source profile.windows /
    ;;
  windows/mobaxterm|mobaxterm)
    source profile.windows /drives
    ;;
  wsl/ubuntu)
    source profile.wsl /mnt
    ;;
  default|'')
    # shellcheck disable=SC2034 # appears unused
    USER_HOME=~
    ;;
  *)
    echo "Unsupported profile: '${BASH_PROFILE}'" >&2
    ;;
esac

echo -n "${BASH_SOURCE[0]} ${BASH_PROFILE}"

source functions
source aliases

shift
# shellcheck disable=SC2086 # quote to prevent globbing and word splitting
# shellcheck disable=SC2048 # use "$@" (with quotes) to prevent whitespace problems
test $# -ne 0 || set -- ${BASH_PROFILE_FEATURES[*]}
# shellcheck disable=SC2046 # quote to prevent word splitting
test $# -ne 0 || set -- $(find feature -type f -printf "%f ")

BASH_PROFILE_FEATURES=()
for feature in "$@"; do
  # Add features only for the available commands.
  if command -v "${feature}" &> /dev/null; then
    # shellcheck source=/dev/null
    if source "feature/${feature}"; then
      BASH_PROFILE_FEATURES+=("${feature}")
    fi
  fi
done

cd ~ || return 2

__end_time=$(date +%s%N)
echo " ${BASH_PROFILE_FEATURES[*]} ($(( (__end_time - __start_time) / 1000000 )) ms)"
unset __start_time __end_time

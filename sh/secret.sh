#!/usr/bin/env bash

function encode_secret() {
  openssl enc -aes-256-cbc -md sha512 -a -e -pbkdf2 -iter 80000 -salt -pass "pass:${1:?passphrase}"
}

function decode_secret() {
  openssl enc -aes-256-cbc -md sha512 -a -d -pbkdf2 -iter 80000 -salt -pass "pass:${1:?passphrase}"
}

function read_passphrase() {
  local -n var_name=${1:-PASSPHRASE}
  local prompt=${2:-"Enter passphrase"}
  echo -n "${prompt}: " >&2
  stty -echo
  # shellcheck disable=SC2034
  IFS= read -r var_name
  stty echo
  echo "" >&2
} 

function create_passphrase() {
  local -n var_ref=${1:-PASSPHRASE}
  local confirm

  while :; do
    read_passphrase var_ref "Enter passphrase"
    read_passphrase confirm "Confirm passphrase" 

    if [ "${var_ref}" = "${confirm}" ]; then
      return 0
    fi

    echo "Secret do not match. Please try again." >&2
  done
}

# Can only return from a sourced script.
[ "$_" != "$0" ] && return 0 2> /dev/null

set -eEuo pipefail

case "${1:-}" in
  -d|--decode)
    shift
    if [ -z "${PASSPHRASE:-}" ]; then
      read_passphrase PASSPHRASE
    fi
    SECRET=${1:?"Encrypted text or file"}
    if [ -f "${SECRET}" ]; then
      decode_secret "${PASSPHRASE}" < "${SECRET}"
    else
      decode_secret "${PASSPHRASE}" <<< "${SECRET}"
    fi
    ;;
  *)
    if [ -z "${PASSPHRASE:-}" ]; then
      create_passphrase PASSPHRASE
    fi
    TEXT=${1:?"Plain text or file"}
    if [ -f "${TEXT}" ]; then
      encode_secret "${PASSPHRASE}" < "${TEXT}"
    else
      encode_secret "${PASSPHRASE}" <<< "${TEXT}"
    fi
    ;;
esac

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
  # shellcheck disable=SC2034 # appears unused
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
true && return 0 2> /dev/null

function main() {
  local passphrase=${PASSPHRASE:-} secret text

  case "${1:-}" in
    -d|--decode)
      shift
      if [ -z "${passphrase:-}" ]; then
        read_passphrase passphrase
      fi
      secret=${1:?"Encrypted text or file"}
      if [ -f "${secret}" ]; then
        decode_secret "${passphrase}" < "${secret}"
      else
        decode_secret "${passphrase}" <<< "${secret}"
      fi
      ;;
    *)
      if [ -z "${passphrase:-}" ]; then
        create_passphrase passphrase
      fi
      text=${1:?"Plain text or file"}
      if [ -f "${text}" ]; then
        encode_secret "${passphrase}" < "${text}"
      else
        encode_secret "${passphrase}" <<< "${text}"
      fi
      ;;
  esac
}

set -eEuo pipefail
main "$@"

#!/usr/bin/env bash
###########################################################
# Read the definitions of aliases and functions.
############################################################
function bash-profile() {
  local dir
  dir=$(dirname "${BASH_SOURCE[0]}")
  source "${dir}/aliases"
  source "${dir}/functions"
}

echo "${BASH_SOURCE[0]}"
bash-profile

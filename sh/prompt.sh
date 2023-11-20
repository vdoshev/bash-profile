#!/usr/bin/env bash
# https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Controlling-the-Prompt

# Emit prompt char sequence for PS1 variable
# shellcheck disable=SC2034
function emit_prompt() {
  # Colors
  local    red='\[\033[0;31m\]'
  local  green='\[\033[0;32m\]'
  local yellow='\[\033[0;33m\]'
  local   blue='\[\033[0;34m\]'
  local purple='\[\033[0;35m\]'
  local   cyan='\[\033[0;36m\]'
  local  white='\[\033[0;37m\]'
  local  reset='\[\033[0m\]'
  # Special characters
  local time='\t' # The time, in 24-hour HH:MM:SS format
  local user='\u' # The username of the current user
  local host='\h' # The hostname, up to the first ‘.’
  local  pwd='\w' # The value of the PWD shell variable
  local  uid='\$' # For root user is '#', and '$' otherwise

  case ${1:-} in
    1|color*)
      echo "${purple}${time} ${red}${user}${white}@${blue}${host}${white}:${green}${pwd}${white}${uid}${reset} "
      ;;
    *)
      echo "${time} ${user}@${host}:${pwd}${uid} "
  esac
}

echo "PS1='$(emit_prompt color)'"

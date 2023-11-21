#!/usr/bin/env bash
# https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Controlling-the-Prompt

declare -A FG_COLOR_CODES=(\
  [black]='0;30m'
  [red]='0;31'
  [green]='0;32'
  [brown]='0;33'
  [blue]='0;34'
  [purple]='0;35'
  [cyan]='0;36'
  [light-gray]='0;37'
  [dark-gray]='1;30'
  [light-red]='1;31'
  [light-green]='1;32'
  [yellow]='1;33'
  [light-blue]='1;34'
  [light-purple]='1;35'
  [light-cyan]='1;36'
  [white]='1;37'
)

declare -A BG_COLOR_CODES=(\
  [black]='0;40m'
  [red]='0;41'
  [green]='0;42'
  [brown]='0;43'
  [blue]='0;44'
  [purple]='0;45'
  [cyan]='0;46'
  [light-gray]='0;47'
  [light-red]='1;41'
  [light-green]='1;42'
  [yellow]='1;43'
  [light-blue]='1;44'
  [light-purple]='1;45'
  [light-cyan]='1;46'
  [white]='1;47'
)

declare -A SPECIAL_CHARS=(\
  [space]=' '
  [time]='\t' # The time, in 24-hour HH:MM:SS format
  [user]='\u' # The username of the current user
  [host]='\h' # The hostname, up to the first ‘.’
  [pwd]='\w'  # The value of the PWD shell variable
  [uid]='\$'  # For root user is '#', and '$' otherwise
)

# Emit ASCII escape sequences for specific keywords.
# shellcheck disable=SC2028
function emit() {
  local keyword chr
  while test $# -gt 0; do
    keyword=$1; shift
    case "${keyword}" in
      fg?*)
        echo -n '\[\033['"${FG_COLOR_CODES[${keyword:3}]}"'m\]'
        ;;
      bg?*)
        echo -n '\[\033['"${BG_COLOR_CODES[${keyword:3}]}"'m\]'
        ;;
      reset)
        echo -n '\[\033[0m\]'
        ;;
      *)
        chr=${SPECIAL_CHARS[${keyword}]}
        echo -n "${chr:-${keyword}}" 
        ;;
    esac
  done
}

# Emit prompt char sequence for PS1 variable
# shellcheck disable=SC2034
function emit_prompt() {
  case ${1:-} in
    no-color) emit time space user @ host : pwd space uid space ;;
    color|*) emit fg.purple time reset space fg.green user @ host reset : fg.light-blue pwd reset uid space ;;
  esac
}

true && return 0 2> /dev/null
echo "PS1='$(emit_prompt "$1")'"

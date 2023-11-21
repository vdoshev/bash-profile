#!/usr/bin/env bash
#
# Usage:
#
# Set a colorized prompt:
#  $ eval $(sh/prompt.sh color)
#
# Set a plain-text prompt (no colors):
#  $ eval $(sh/prompt.sh no-color)
#
# Print colorized text:
#  $ source sh/prompt.sh
#  $ echo -e "$(emit fg.red 'Hello red color!' fg._ ' No more red text.')"
 
# https://www.shellhacks.com/bash-colors/
declare -A FG_COLOR_CODES=(\
  [_]=0
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
  [_]=0
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

# Emit ASCII escape sequences for echo and printf commands.
# shellcheck disable=SC2028
function emit() {
  local keyword
  for keyword in "$@"; do
    case "${keyword}" in
      title) echo -n "\e]0;${BASH} ${PWD}\a" ;;
      fg?*)  echo -n '\e['"${FG_COLOR_CODES[${keyword:3}]}"'m' ;;
      bg?*)  echo -n '\e['"${BG_COLOR_CODES[${keyword:3}]}"'m' ;;
      *)     echo -n "${keyword}" ;;
    esac
  done
}

# https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Controlling-the-Prompt
declare -A SPECIAL_CHARS=(\
  [space]=' '
  [nl]='\n'   # new line
  [time]='\t' # the time, in 24-hour HH:MM:SS format
  [user]='\u' # the username of the current user
  [host]='\h' # the hostname, up to the first ‘.’
  [pwd]='\w'  # the value of the PWD shell variable
  [uid]='\$'  # for root user is '#', and '$' otherwise
)

# Emit ASCII escape sequences for prompt variables (PS1, etc.)
# shellcheck disable=SC2028,SC2016
function emit_ps() {
  local keyword
  for keyword in "$@"; do
    case "${keyword}" in
      title) echo -n '\[\033]0;$BASH $PWD\007\]' ;;
      fg?*)  echo -n '\[\033['"${FG_COLOR_CODES[${keyword:3}]}"'m\]' ;;
      bg?*)  echo -n '\[\033['"${BG_COLOR_CODES[${keyword:3}]}"'m\]' ;;
      *)     echo -n "${SPECIAL_CHARS[${keyword}]:-${keyword}}" ;;
    esac
  done
}

# Emit characters sequence for prompt variables (PS1, etc.)
function emit_prompt() {
  case ${1:-1} in
    0|no-color)
      emit_ps title time space user @ host : pwd nl uid space
      ;;
    1|color|*)
      emit_ps title fg.purple time fg._ space fg.green user @ host fg._ : fg.light-blue pwd fg._ nl uid space
      ;;
  esac
}

true && return 0 2> /dev/null
echo "export PS1='$(emit_prompt "$1")'"

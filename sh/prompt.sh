#!/usr/bin/env bash
#
# Usage:
#
# Set a colorized prompt:
#  eval "$(sh/prompt.sh)"
#
# Set a plain-text prompt (no colors):
#  eval "$(sh/prompt.sh no-color)"
#
# Print a colorized text:
#  . sh/prompt.sh
#  echo_e fg.red Red fg. ' color'
#  echo_e fg.FF0000 RR fg.00FF00 GG fg.0000FF BB fg. ' color'
#
# Embed a colorized text:
#  . sh/prompt.sh
#  echo -e "Plain text with $(emit fg.yellow yellow fg.) fragment"
 
# https://www.shellhacks.com/bash-colors/
# shellcheck disable=SC2034 # appears unused
declare -A CH_STYLES=([normal]=0 [bold]=1 [underlined]=4 [blinking]=5 [reverse]=7)

declare -A FG_COLOR_CODES=([_]=0
  [black]='0;30m' [red]='0;31' [green]='0;32' [brown]='0;33'
  [blue]='0;34' [purple]='0;35' [cyan]='0;36' [light-gray]='0;37'
  [dark-gray]='1;30' [light-red]='1;31' [light-green]='1;32' [yellow]='1;33'
  [light-blue]='1;34' [light-purple]='1;35' [light-cyan]='1;36' [white]='1;37'
)

declare -A BG_COLOR_CODES=([_]=0
  [black]='0;40m' [red]='0;41' [green]='0;42' [brown]='0;43'
  [blue]='0;44' [purple]='0;45' [cyan]='0;46' [light-gray]='0;47'
  [dark-gray]='1;40' [light-red]='1;41' [light-green]='1;42' [yellow]='1;43'
  [light-blue]='1;44' [light-purple]='1;45' [light-cyan]='1;46' [white]='1;47'
)

# A0B0C0 -> 160;176;192
function rgb_hex2dec() {
  echo "$((16#${1:0:2}));$((16#${1:2:2}));$((16#${1:4:2}))"
}

# FF0000 -> 38;2;255;0;0
# red    -> 0;31
function emit_fgcolor() {
  echo "${FG_COLOR_CODES[${1:-_}]:-"38;2;$(rgb_hex2dec "$1")"}"
}

# 0000FF -> 48;2;0;0;255
# blue   -> 0;34
function emit_bgcolor() {
  echo "${BG_COLOR_CODES[${1:-_}]:-"48;2;$(rgb_hex2dec "$1")"}"
}

# Emit ASCII escape sequences for echo and printf commands.
# shellcheck disable=SC2028 # echo won't expand escape sequences
function emit() {
  local keyword
  for keyword in "$@"; do
    case "${keyword}" in
      title) echo -n "\e]0;${BASH} ${PWD}\a" ;;
      fg.*)  echo -n "\e[$(emit_fgcolor "${keyword:3}")m" ;;
      bg.*)  echo -n "\e[$(emit_bgcolor "${keyword:3}")m" ;;
      *)     echo -n "${keyword}" ;;
    esac
  done
}

function echo_e() {
  echo -e "$(emit "$@")"
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
# shellcheck disable=SC2028 # echo won't expand escape sequences
# shellcheck disable=SC2016 # expressions don't expand in single quotes
function emit_ps() {
  local keyword
  for keyword in "$@"; do
    case "${keyword}" in
      title) echo -n '\[\033]0;$BASH $PWD\007\]' ;;
      git)   echo -n '`emit_git_info`' ;;
      fg.*)  echo -n '\[\033['"$(emit_fgcolor "${keyword:3}")"'m\]' ;;
      bg.*)  echo -n '\[\033['"$(emit_bgcolor "${keyword:3}")"'m\]' ;;
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
      emit_ps title \
          fg.purple time fg. space \
          fg.green user @ host fg. : \
          fg.light-blue pwd fg. space \
          fg.light-cyan git fg. nl \
          uid space
      ;;
  esac
}

function emit_git_info() {
  local dir ref
  dir=$(builtin pwd)
  while [[ "${#dir}" -gt 0 ]]; do
    if [[ -f "${dir}"/.git/HEAD ]]; then
      ref=$(< "${dir}"/.git/HEAD)
      echo "(${ref##ref: refs/heads/})"
      return 0
    fi
    dir=${dir%/*}
  done
}

true && return 0 2> /dev/null

declare -f emit_git_info
cat << EOD
export -f emit_git_info
OLD_PS1=\$PS1
export PS1='$(emit_prompt "$1")'
EOD

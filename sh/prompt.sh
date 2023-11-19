#!/usr/bin/env bash

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
     RESET='\[\033[0m\]'
    YELLOW='\[\033[1;35m\]'
       RED='\[\033[38;2;255;100;100m\]'
     GREEN='\[\033[38;2;100;255;100m\]'
      BLUE='\[\033[38;2;100;100;255m\]'

    PS1="${YELLOW}\t${RESET} ${RED}\u${RESET}@${BLUE}\h${RESET}:${GREEN}\w${RESET}\$ "
    unset CHROOT RESET YELLOW RED BLUE GREEN
else
    PS1='\t \u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

#
# ~/.bash_profile
#

# add user scripts folder to path
PATH=$HOME/.scripts:$PATH

# required for bspwm
XDG_CONFIG_HOME="$HOME/.config"
export XDG_CONFIG_HOME

# fix java programs not drawing
export _JAVA_AWT_WM_NONREPARENTING=1

# set editor for sudoedit
SUDO_EDITOR="/usr/bin/nvim"
export SUDO_EDITOR

# enable perfect scrolling in firefox
MOZ_USE_XINPUT2=1
export MOZ_USE_XINPUT2

# term colors for programs like man
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;38;5;74m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[38;5;246m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[04;38;5;146m'

# start and stop ssh agent
if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval `ssh-agent -s -t 1h`
fi

trap 'test -n "$SSH_AUTH_SOCK" && eval `/usr/bin/ssh-agent -k`' 0

[[ -f ~/.bashrc ]] && . ~/.bashrc

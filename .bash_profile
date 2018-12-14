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

# start and stop ssh agent
if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval `ssh-agent -s -t 1h`
fi

trap 'test -n "$SSH_AUTH_SOCK" && eval `/usr/bin/ssh-agent -k`' 0

[[ -f ~/.bashrc ]] && . ~/.bashrc

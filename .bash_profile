#
# ~/.bash_profile
#

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

[[ -f ~/.bashrc ]] && . ~/.bashrc

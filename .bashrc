#
# ~/.bashrc
#

# Allow duplicating termite windows
source /etc/profile.d/vte.sh

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# aliases
alias ls='ls -gh --group-directories-first --color=auto'
alias la='ls -A'
alias grep='grep --color=auto'
alias startx='startx -- -keeptty > ~/.xorg.log 2>&1'

# Prompt
PS1='[\u@\h \W]\$ '

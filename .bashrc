#
# ~/.bashrc
#

# Allow duplicating termite windows
source /etc/profile.d/vte.sh

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# aliases
alias ls='ls --group-directories-first --color=auto'
alias ll='ls -lh'
alias la='ls -lhA'
alias grep='grep --color=auto'
alias startx='startx -- -keeptty > ~/.xorg.log 2>&1'
alias vim='nvim'

# Prompt
PS1='[\u@\h \W]\$ '

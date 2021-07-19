#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# aliases
alias ls='ls --group-directories-first --color=auto'
alias ll='ls -lh'
alias la='ls -lhA'
alias grep='grep --color=auto -n'
alias startx='startx -- -keeptty > ~/.xorg.log 2>&1'
alias vim='nvim'

# Prompt
__prompt_command(){
    local EXIT="$?" # this must be called first

    if [ $(id -u) == 0 ]; then
        local userCol='\[\e[31m\]'
    else
        local userCol='\[\e[36m\]'
    fi

    local dirCol='\[\e[34m\]'
    local clearCol='\[\e[0m\]'
    local warnCol='\[\e[31m\]'

    PS1="[$userCol\u@\h $dirCol\W"

    if [ $EXIT != 0 ]; then
        PS1+="$warnCol $EXIT"
    fi

    PS1+="$clearCol]\$ "
}

# Append prompt to the one provided by vte
if [ "$TERM" = "xterm-termite" ]; then
    source /etc/profile.d/vte.sh
    PROMPT_COMMAND="${PROMPT_COMMAND};__prompt_command"
    TERM="xterm-color"
else
    PROMPT_COMMAND=__prompt_command
fi

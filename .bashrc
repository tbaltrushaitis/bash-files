# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
#    . /etc/bash_completion
#fi

# Source global definitions
if [ -f /etc/bash.bashrc ]; then
        . /etc/bash.bashrc
fi

# Options definitions.
if [ -f ~/.bash_opts ]; then
    . ~/.bash_opts
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Functions definitions.
if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

# SSH-Agent
if [ -f ~/.bash_ssh-agent ]; then
    . ~/.bash_ssh-agent
fi

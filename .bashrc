##  ------------------------------------------------------------------------  ##
##                      Bash Environment Configs Caller                       ##
##  ------------------------------------------------------------------------  ##

##  If not running interactively, don't do anything
[ -z "$PS1" ] && return

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
#    . /etc/bash_completion
#fi

##  Source global definitions
if [ -f /etc/bash.bashrc ]; then
    . /etc/bash.bashrc
    echo -e "\t${BWhite}ENV:\t exported [/etc/bash.bashrc]";
fi

##  Options definitions.
if [ -f "$HOME/.bash_opts" ]; then
    . "$HOME/.bash_opts"
    echo -e "\t${BWhite}ENV:\t exported [$HOME/.bash_opts]";
fi

##  Alias definitions.
if [ -f "$HOME/.bash_aliases" ]; then
    . "$HOME/.bash_aliases"
    echo -e "\t${BWhite}ENV:\t exported [$HOME/.bash_aliases]";
fi

##  Functions definitions.
if [ -f "$HOME/.bash_functions" ]; then
    . "$HOME/.bash_functions"
    echo -e "\t${BWhite}ENV:\t exported [$HOME/.bash_functions]";
fi

##  SSH-Agent
#if [ -f "$HOME/.bash_ssh-agent" ]; then
#    . "$HOME/.bash_ssh-agent"
#    echo -e "\t${BWhite}ENV:\t exported [$HOME/.bash_ssh-agent]";
#fi

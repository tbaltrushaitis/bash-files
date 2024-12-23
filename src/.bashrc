#!/usr/bin/env bash
##  ┌──────────────────────────────────────────────────────────────────┐
##  │  ____    _    ____  _   _           _____ ___ _     _____ ____   │
##  │ | __ )  / \  / ___|| | | |         |  ___|_ _| |   | ____/ ___|  │
##  │ |  _ \ / _ \ \___ \| |_| |  _____  | |_   | || |   |  _| \___ \  │
##  │ | |_) / ___ \ ___) |  _  | |_____| |  _|  | || |___| |___ ___) | │
##  │ |____/_/   \_\____/|_| |_|         |_|   |___|_____|_____|____/  │
##  │                                                                  │
##  └──────────────────────────────────────────────────────────────────┘
##  ------------------------------------------------------------------------  ##
##                      Bash Environment Configs Caller                       ##
##  ------------------------------------------------------------------------  ##
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
  *i*) ;;
  *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color|*-256color)
    color_prompt=yes
  ;;
esac

# uncomment for a colored prompt, if the terminal has the capability;
force_color_prompt=yes

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
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
  xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
  ;;

  *)
  ;;
esac


##  ------------------------------------------------------------------------  ##
##                           Local user PATHs                                 ##
##  ------------------------------------------------------------------------  ##
##  set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then PATH="$PATH:$HOME/bin"; fi
if [ -d "$HOME/.local/bin" ]; then PATH="$PATH:$HOME/.local/bin"; fi


##  ------------------------------------------------------------------------  ##
##     Enable programmable completion features (you don't need to enable      ##
##     this, if it's already enabled in /etc/bash.bashrc and /etc/profile     ##
##     sources /etc/bash.bashrc).                                             ##
##  ------------------------------------------------------------------------  ##
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


##  ------------------------------------------------------------------------  ##
##                         Enable color support of ls                         ##
##  ------------------------------------------------------------------------  ##
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

##  ------------------------------------------------------------------------  ##
##                    Colored GCC warnings and errors                         ##
##  ------------------------------------------------------------------------  ##
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


##  ------------------------------------------------------------------------  ##
##                      NVM (Node Version Manager) Loader                     ##
##  ------------------------------------------------------------------------  ##
export NVM_DIR="${HOME}/.nvm"


##  ------------------------------------------------------------------------  ##
##                           Load RC files                                    ##
##  ------------------------------------------------------------------------  ##
declare -a RC_FILES=(
# "${HOME}/.bash_colors"          # Shell colors
# "/etc/bash.bashrc"              # System-wide .bashrc file for interactive bash(1) shells
# "/etc/bash_completion"          # System-wide bash_completion file
# "${HOME}/.bash_opts"            # Options
# "${HOME}/.bash_aliases"         # Aliases
# "${HOME}/.bash_functions"       # Functions
"${NVM_DIR}/nvm.sh"             # This loads nvm
"${NVM_DIR}/bash_completion"    # This loads nvm bash_completion
# "${HOME}/.bash_greeting"        # Greeting, motd etc.
# "${HOME}/.bash_ssh-agent"       # SSH-Agent
)

for BF_RC in "${RC_FILES[@]}" ;
  do
    if [ -f "${BF_RC}" ]; then
      echo -e "\t${Cyan}Load${NC}\t [${White}${BF_RC}${NC}]" ;
      . "${BF_RC}"
    else
      echo -e "\t${Yellow}Skip${NC}\t [${Gray}${BF_RC}${NC}]" ;
    fi
  done

##  ------------------------------------------------------------------------  ##

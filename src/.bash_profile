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
##  ~/.bash_profile - executed by Bourne-compatible login shells
##  See /usr/share/doc/bash/examples/startup-files for examples
##  ------------------------------------------------------------------------  ##

ME=$(basename -- "$0");
echo -e "\n------------------------------------------------------------------" ;
echo -e "\n\tExecuting as [${ME}:$$] with [$-]\n" ;


##  ------------------------------------------------------------------------  ##
##                           Load RC files                                    ##
##  ------------------------------------------------------------------------  ##
declare -a RC_FILES=(
"${HOME}/.bash_colors"          # Shell colors
"${HOME}/.env"                  # ENV custom variables
"/etc/bashrc"                   # Global definitions
"/etc/bash.bashrc"              # System-wide .bashrc file for interactive bash(1) shells
"/etc/bash_completion"          # System-wide bash_completion file
"${HOME}/.bash_opts"            # Options
"${HOME}/.bash_aliases"         # Aliases
"${HOME}/.bash_functions"       # Functions
"${HOME}/.bashrc"               # .bashrc file
"${HOME}/.profile"              # User-specific
# "${NVM_DIR}/nvm.sh"             # This loads nvm
# "${NVM_DIR}/bash_completion"    # This loads nvm bash_completion
"${HOME}/.bash_greeting"        # Greeting, motd etc.
# "${HOME}/.bash_ssh-agent"       # SSH-Agent
)

for BF_RC in "${RC_FILES[@]}" ; do
  if [ -f "${BF_RC}" ]; then
    echo -e "\t${Cyan}Load${NC}\t [${White}${BF_RC}${NC}]" ;
    . "${BF_RC}"
  else
    echo -e "\t${Yellow}Skip${NC}\t [${Gray}${BF_RC}${NC}]" ;
  fi
done

echo -e "---------------------------------------------------------------------";

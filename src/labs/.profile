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
##  ~/.profile
##  see /usr/share/doc/bash/examples/startup-files for examples.
##  ------------------------------------------------------------------------  ##

##  the default umask is set in /etc/profile; for setting the umask
##  for ssh logins, install and configure the libpam-umask package.
## umask 022

##  if running bash  ##
if [ -n "${BASH_VERSION}" ]; then
  # include .bash_profile if it exists
  local PROFILE=${HOME}/.bash_profile;
  if [ -f "${PROFILE}" ]; then
    . "${PROFILE}"
    echo -e "\t[${BWhite}$(date +'%F %T %Z')${NC}] ${BPurple}\t Exported [${PROFILE}]";
  fi
fi

# ##  set PATH so it includes user's private bin if it exists
# if [ -d "$HOME/bin" ] ; then
#   PATH="$PATH:$HOME/bin"
# fi
#
# if [ -d "$HOME/.local/bin" ] ; then
#   PATH="$PATH:$HOME/.local/bin"
# fi

mesg n || true

echo -e "\n"
echo -e "\t[${BWhite}$(date)${NC}]"
echo -e "\t[${BWhite}$(date +'%F %T %Z')${NC}]\t${BYellow}USER${NC} Session Started"
echo -e "\n"

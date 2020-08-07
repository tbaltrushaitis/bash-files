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
##  ~/.bash_profile - executed by Bourne-compatible login shells.
##  see /usr/share/doc/bash/examples/startup-files for examples.
##  ------------------------------------------------------------------------  ##

ME=$(basename -- "$0");
echo -e "\n\tExecuting as [${ME}:$$]\n" ;


##  ------------------------------------------------------------------------  ##
##                         Shell colors definitions                           ##
##  ------------------------------------------------------------------------  ##
RC_FILE=${HOME}/.bash_colors;
if [ -f "${RC_FILE}" ]; then
  . "${RC_FILE}"
  echo -e "\tExported [${Orange}${RC_FILE}${NC}]" ;
fi


##  ------------------------------------------------------------------------  ##
##                         Source global definitions                          ##
##  ------------------------------------------------------------------------  ##
RC_FILE=/etc/bashrc;
if [ -f "${RC_FILE}" ]; then
  . "${RC_FILE}"
  echo -e "\tExported [${BGreen}${RC_FILE}${NC}]" ;
fi


##  ------------------------------------------------------------------------  ##
##                               .bashrc file                                 ##
##  ------------------------------------------------------------------------  ##

RC_FILE=${HOME}/.bashrc;
if [ -f "${RC_FILE}" ]; then
  . "${RC_FILE}"
  # Need to restore variable value
  RC_FILE=${HOME}/.bashrc;
  echo -e "\tExported [${Blue}${RC_FILE}${NC}]" ;
fi


##  ------------------------------------------------------------------------  ##
##                            Greeting, motd etc.                             ##
##  ------------------------------------------------------------------------  ##

echo -e "\n\tThis is [${Cyan}BASH${NC}:${Yellow}${BASH_VERSION%(*}${NC}] \
in [${Cyan}TTY${NC}:${Yellow}$(tty)${NC}]" ;

if [ -f "${HOME}/.bash_greeting" ]; then
  . "${HOME}/.bash_greeting"
  # echo -e "\tExported [${Blue}${HOME}/.bash_greeting${NC}]" ;
fi

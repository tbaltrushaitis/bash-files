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
echo -e "\n\tExecuted as process [${ME}:$$]\n"

##  ------------------------------------------------------------------------  ##
##                               .bashrc file                                 ##
##  ------------------------------------------------------------------------  ##

# include .bash_*file if it exists
RC_FILE=${HOME}/.bashrc;
if [ -f "${RC_FILE}" ]; then
  . "${RC_FILE}"
  echo -e "\tExported [${BBlue}${RC_FILE}${NC}]" ;
fi

RC_FILE=.bash_greeting;
if [ "root" == "${USER}" ] && [ -f "/root/${RC_FILE}" ]; then
  . "/root/${RC_FILE}" ;
  echo -e "\tExported [${BBlue} /root/${RC_FILE} ${NC}]" ;
else
  . ${HOME}/${RC_FILE} ;
  echo -e "\tExported [${BBlue} ${HOME}/${RC_FILE} ${NC}]" ;
fi

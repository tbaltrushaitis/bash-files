#!/usr/bin/env bash
##  ┌──────────────────────────────────────────────────────────────┐
##  │  ____    _    ____  _   _       _____ ___ _     _____ ____   │
##  │ | __ )  / \  / ___|| | | |     |  ___|_ _| |   | ____/ ___|  │
##  │ |  _ \ / _ \ \___ \| |_| |_____| |_   | || |   |  _| \___ \  │
##  │ | |_) / ___ \ ___) |  _  |_____|  _|  | || |___| |___ ___) | │
##  │ |____/_/   \_\____/|_| |_|     |_|   |___|_____|_____|____/  │
##  │                                                              │
##  └──────────────────────────────────────────────────────────────┘
##  ------------------------------------------------------------------------  ##
##  /root/.bash_profile
##  see /usr/share/doc/bash/examples/startup-files for examples.
##  ------------------------------------------------------------------------  ##
# ~/.bash_profile: executed by Bourne-compatible login shells.

ME=$(basename -- "$0");
echo -e "\n\tExecuted as process [${ME}:$$]\n"

##  ------------------------------------------------------------------------  ##
##                               .bashrc file                                 ##
##  ------------------------------------------------------------------------  ##

# include .bash_*file if it exists
SRC_FILE=${HOME}/.bashrc;
if [ -f "${SRC_FILE}" ]; then
  . "${SRC_FILE}"
  echo -e "\tExported [${BPurple}${SRC_FILE}${NC}]";
fi

mesg n || true

echo -e "${NC}"
echo -e "\t${BYellow}${SUDO_USER}${NC}, you have ${BRed}${On_Black}${USER} privileges${NC}. ${BYellow}${On_Blue}Be careful, please.${NC}"
echo -e "\t[${BWhite}$(date +'%F %T %Z')${NC}] ${BRed}Go on now ... ${NC}"
echo -e "${NC}"

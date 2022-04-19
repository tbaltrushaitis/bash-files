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
##  ~/.bash_logout: executed by bash(1) when login shell exits.               ##
##  ------------------------------------------------------------------------  ##

# when leaving the console, clear the screen to increase privacy
# if [ "$SHLVL" = 1 ]; then
#   [ -x /usr/bin/clear ] && /usr/bin/clear -q
# fi

##  ------------------------------------------------------------------------  ##
##                     Function to run upon exit of shell                     ##
##  ------------------------------------------------------------------------  ##

function _exit () {
  echo -e "\n\n" ;
  echo -e "\t${Cyan}Hasta la vista${NC}, ${Yellow}${USER}${NC}!" ;
  echo -e "\n\n" ;
  echo -e "\t[${Gray}$(date +'%T')${NC}] ${White}Session Closed${NC} for user [${Yellow}${USER}${NC}:${Orange}${EUID}${NC}]" ;
  echo -e "\n\n" ;
}

trap _exit EXIT

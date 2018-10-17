##  ┌──────────────────────────────────────────────────────────────┐
##  │  ____    _    ____  _   _       _____ ___ _     _____ ____   │
##  │ | __ )  / \  / ___|| | | |     |  ___|_ _| |   | ____/ ___|  │
##  │ |  _ \ / _ \ \___ \| |_| |_____| |_   | || |   |  _| \___ \  │
##  │ | |_) / ___ \ ___) |  _  |_____|  _|  | || |___| |___ ___) | │
##  │ |____/_/   \_\____/|_| |_|     |_|   |___|_____|_____|____/  │
##  │                                                              │
##  └──────────────────────────────────────────────────────────────┘
##  ------------------------------------------------------------------------  ##
##  ~/.bash_profile
##  see /usr/share/doc/bash/examples/startup-files for examples.
##  ------------------------------------------------------------------------  ##

ME=$(basename -- "$0")
echo -e "\n\tExecuted from [${ME}:$$]\n"

# echo
# echo "# arguments called with ---->  ${@}     "
# echo "# \$1 ---------------------->  $1       "
# echo "# \$2 ---------------------->  $2       "
# echo "# path to ME --------------->  ${0}     "
# echo "# parent path -------------->  ${0%/*}  "
# echo "# \${0##*/} ---------------->  ${0##*/} "
# echo "# ME name ------------------>  ${ME}    "
# echo

# include .bashrc if it exists
if [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
  echo -e "\tExported [${BPurple}${HOME}/.bashrc${NC}]"
fi

##  set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then PATH="$PATH:$HOME/bin"; fi
if [ -d "$HOME/.local/bin" ]; then PATH="$PATH:$HOME/.local/bin"; fi

mesg n || true

echo -e "\n"
echo -e "\t${BWhite}$(date)${NC}"
echo -e "\t${BWhite}$(date +'%Y-%m-%d %H:%M:%S')${NC} ${BCyan}Session Started${NC} for user ${BYellow}${USER}${NC}"
echo -e "\n"

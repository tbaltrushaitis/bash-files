##		 ┌──────────────────────────────────────────────────────────────┐
##		 │  ____    _    ____  _   _       _____ ___ _     _____ ____   │
##		 │ | __ )  / \  / ___|| | | |     |  ___|_ _| |   | ____/ ___|  │
##		 │ |  _ \ / _ \ \___ \| |_| |_____| |_   | || |   |  _| \___ \  │
##		 │ | |_) / ___ \ ___) |  _  |_____|  _|  | || |___| |___ ___) | │
##		 │ |____/_/   \_\____/|_| |_|     |_|   |___|_____|_____|____/  │
##		 │                                                              │
##		 └──────────────────────────────────────────────────────────────┘
##  ------------------------------------------------------------------------  ##
##  ~/.bash_profile
##  see /usr/share/doc/bash/examples/startup-files for examples.
##  the files are located in the bash-doc package.
##  ------------------------------------------------------------------------  ##
# ~/.bash_profile: executed by Bourne-compatible login shells.

ME=$(basename -- "$0")
echo -ne "\n\tExecuting from [${ME}:$$]\n"

##  if running bash
# if [ "$BASH" ]; then
# fi

if [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
  echo -e "\t${BGreen}ENV:${NC}\t ${BPurple}Exported [$HOME/.bashrc]${NC}"
fi

##  set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then PATH="$PATH:$HOME/bin"; fi
if [ -d "$HOME/.local/bin" ]; then PATH="$PATH:$HOME/.local/bin"; fi

mesg n || true

echo -e "\n"
echo -e "\t${BYellow}${SUDO_USER}${NC}, you have ${BRed}${On_Black}${USER} privileges${NC}. ${BYellow}${On_Blue}Be careful, please.${NC}"
echo -e "\t${BWhite}$(date)${NC}"
echo -e "\t${BWhite}$(date +'%Y-%m-%d')${NC}"
echo -e "\t${BRed}Go on now ... ${NC}"
echo -e "\n"

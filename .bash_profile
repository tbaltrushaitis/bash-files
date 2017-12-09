##  ------------------------------------------------------------------------  ##
##  ~/.bash_profile
##  see /usr/share/doc/bash/examples/startup-files for examples.
##  the files are located in the bash-doc package.
##  ------------------------------------------------------------------------  ##

##  the default umask is set in /etc/profile; for setting the umask
##  for ssh logins, install and configure the libpam-umask package.
#umask 022

ME=$(basename -- "$0")
echo -ne "\n\t${BGreen}ENV:${NC}:\t Executing from [${ME}:$$]";

# echo
# echo "# arguments called with ---->  ${@}     "
# echo "# \$1 ---------------------->  $1       "
# echo "# \$2 ---------------------->  $2       "
# echo "# path to ME --------------->  ${0}     "
# echo "# parent path -------------->  ${0%/*}  "
# echo "# \${0##*/} ---------------->  ${0##*/} "
# echo "# ME name ------------------>  ${ME}    "
# echo

##  if running bash
# if [ "$BASH" ]; then
# fi

# include .bashrc if it exists
if [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
  echo -e "\t${BGreen}ENV:${NC}\t ${BPurple}Exported [$HOME/.bashrc]${NC}";
fi

##  set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then PATH="$PATH:$HOME/bin"; fi
if [ -d "$HOME/.local/bin" ]; then PATH="$PATH:$HOME/.local/bin"; fi

mesg n || true

echo -ne "\n"
echo -e "\t${BWhite}$(date)${NC}"
echo -e "\t${BWhite}$(date +'%Y-%m-%d')${NC}\t${BYellow}USER${NC} Session Started"
echo -ne "\n"

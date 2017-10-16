##  ------------------------------------------------------------------------  ##
##  ~/.bash_profile
##  see /usr/share/doc/bash/examples/startup-files for examples.
##  the files are located in the bash-doc package.
##  ------------------------------------------------------------------------  ##

##  the default umask is set in /etc/profile; for setting the umask
##  for ssh logins, install and configure the libpam-umask package.
#umask 022

me=$(basename -- "$0")
echo -e "\n\tENV:\t Executing from [${me}:$$]";

# echo
# echo "# arguments called with ---->  ${@}     "
# echo "# \$1 ---------------------->  $1       "
# echo "# \$2 ---------------------->  $2       "
# echo "# path to me --------------->  ${0}     "
# echo "# parent path -------------->  ${0%/*}  "
# echo "# my name ------------------>  ${0##*/} "
# echo

##  if running bash
# if [ "$BASH" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
        echo -e "\t${BPurple}ENV:\t exported [$HOME/.bashrc]";
    fi
# fi

##  set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$PATH:$HOME/bin"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$PATH:$HOME/.local/bin"
fi

mesg n || true

echo -ne "\n"
echo -e "\t${BWhite}$(date)${NC}"
echo -e "\t${BWhite}$(date +'%Y-%m-%d')${NC}\t${BYellow}USER${NC} Session Started"
echo -ne "\n"

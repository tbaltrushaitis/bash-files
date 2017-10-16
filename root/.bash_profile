##  ------------------------------------------------------------------------  ##
##  ~/.bash_profile
##  see /usr/share/doc/bash/examples/startup-files for examples.
##  the files are located in the bash-doc package.
##  ------------------------------------------------------------------------  ##
# ~/.bash_profile: executed by Bourne-compatible login shells.

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

if [ "$BASH" ]; then
    if [ -f $HOME/.bashrc ]; then
        . $HOME/.bashrc
        echo -e "\t${BPurple}ENV:\t exported [$HOME/.bashrc]";
    fi
fi

mesg n || true
echo -ne "\n";
echo -ne "\n\t${BYellow}${SUDO_USER}${NC}, you are ${BRed}${USER}${NC} from now. ${BYellow}${On_Blue}Be careful, please.${NC}\n"
echo -e "\t${BWhite}$(date)${NC}"
echo -e "\t${BWhite}$(date +'%Y-%m-%d')${NC}\t${BRed}Go on now ... ${NC}"
echo -ne "\n";

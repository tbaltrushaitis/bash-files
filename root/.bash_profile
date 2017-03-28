##  ------------------------------------------------------------------------  ##
##  ~/.bash_profile
##  see /usr/share/doc/bash/examples/startup-files for examples.
##  the files are located in the bash-doc package.
##  ------------------------------------------------------------------------  ##
# ~/.bash_profile: executed by Bourne-compatible login shells.

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

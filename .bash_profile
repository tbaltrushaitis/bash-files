##  ------------------------------------------------------------------------  ##
##  ~/.bash_profile
##  see /usr/share/doc/bash/examples/startup-files for examples.
##  the files are located in the bash-doc package.
##  ------------------------------------------------------------------------  ##

##  the default umask is set in /etc/profile; for setting the umask
##  for ssh logins, install and configure the libpam-umask package.
#umask 022

##  if running bash
if [ "$BASH" ]; then
    # include .bashrc if it exists
    if [ -f "~/.bashrc" ]; then
        . "~/.bashrc"
        echo -e "\t${BWhite}ENV:\t exported vars from [~/.bashrc]:\n";
    fi
fi

##  set PATH so it includes user's private bin if it exists
if [ -d "~/bin" ] ; then
    PATH="$PATH:~/bin"
fi

if [ -d "~/.local/bin" ] ; then
    PATH="$PATH:~/.local/bin"
fi

mesg n || true

echo -e "\t${BWhite}$(date)${NC}"
echo -e "\t${BWhite}$(date +'%Y%m%d')${NC}"
echo -e "\t${BYellow}USER${NC} Session Started";
echo -e ""

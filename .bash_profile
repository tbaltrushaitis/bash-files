##  ------------------------------------------------------------------------  ##
##  ~/.bash_profile
##  see /usr/share/doc/bash/examples/startup-files for examples.
##  the files are located in the bash-doc package.
##  ------------------------------------------------------------------------  ##

##  the default umask is set in /etc/profile; for setting the umask
##  for ssh logins, install and configure the libpam-umask package.
#umask 022

##  if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

##  set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$PATH:$HOME/bin"
fi
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$PATH:$HOME/.local/bin"
fi

mesg n || true
printf "\nUSER Session Started\n";
date

##  ------------------------------------------------------------------------  ##
##                             Commands Aliases                               ##
##  ------------------------------------------------------------------------  ##

##  Become root
alias zz='sudo -i'

alias c='clear'
alias q='exit'
alias e='exit'
alias qq='exit'

##  handy shortcuts
alias ..='cd ..'
alias h='history'
alias j='jobs -l'
alias which='type -a'

##  Process management
alias k9='kill -9'

##  screen routine
alias scs='screen -ls'
alias scx='screen -x'
alias screenls='screen -ls'

##  nodejs processes
alias psnode='ps ax | grep node'

##  npm commands
alias npms='npm start'
alias npmr='npm run'
alias npmt='npm run test'
alias npmb='npm run build'

##  logs parsing
alias visits='visits'

##  confirmation
alias cp='cp -prb'
alias ln='ln -i'

##  Parenting changing perms on / #
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

##  do not delete / or prompt if deleting more than 3 files at a time
alias rm='rm -i --preserve-root'

##  -> Prevents accidentally clobbering files.
alias mkdir='mkdir -p'

##  Show text file without comment (#) lines
alias nocomment='grep -Ev '\''^(#|$)'\'''

##  Pretty-print of some PATH variables:
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'

##  Makes a more readable output.
alias du='du -kh'
alias df='df -kTH'

##  Colorize the grep command output for ease of use (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

##  Generate sha1 digest
alias sha1='openssl sha1'

##  Make mount command output pretty and human readable format
alias mount='mount | column -t'

##  Grabs the disk usage in the current directory
alias usage='du -c 2>/dev/null | tail -1'
##  Gets the total disk usage on your machine
alias totalusage='df -hl --total | grep total'
##  Shows the individual partition usages without the temporary memory values
alias partusage='df -hlT --exclude-type=tmpfs --exclude-type=devtmpfs'
##  Gives you what is using the most space. Both directories and files. Varies on current directory
#alias most='du -hsx * | grep G | sort -r | head -10'
alias most='du -shx * | grep -w "[0-9]*G"'

##  Set 775 on folders and 664 on files
alias rights='sudo find . -type f -exec chmod 664 {} \; && sudo find . -type d -exec chmod 775 {} \; && sudo find . -type f -name "*.sh" -exec sudo chmod a+x {} \;'

##  Do not wait interval 1 second, go fast
alias fastping='ping -c 100 -s.2'

##  Show open ports
##  Use netstat command to quickly list all TCP/UDP port on the server:
alias ports='netstat -tulanp'

##  Control firewall (iptables) output
##  shortcut for iptables and pass it via sudo
alias ipt='sudo /sbin/iptables'

##  display all rules
alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'
alias firewall=iptlist

##  Debug web server / cdn problems with curl
##  get web server headers
alias curli='curl -I'
##  find out if remote server supports gzip / mod_deflate or not
alias headerc='curl -I --compress'

##  Control web servers
##  also pass it via sudo so whoever is admin can reload it without calling you
#alias nginxreload='sudo /usr/local/nginx/sbin/nginx -s reload'
#alias nginxtest='sudo /usr/local/nginx/sbin/nginx -t'
#alias lightyload='sudo /etc/init.d/lighttpd reload'
#alias lightytest='sudo /usr/sbin/lighttpd -f /etc/lighttpd/lighttpd.conf -t'
alias httpdreload='sudo /usr/sbin/apachectl -k graceful'
alias httpdrestart='sudo /etc/init.d/httpd restart'
alias httpdtest='sudo /usr/sbin/apachectl -t && /usr/sbin/apachectl -t -D DUMP_VHOSTS'

##  ------------------------------------------------------------------------  ##
##         Get system memory, cpu usage, and gpu memory info quickly          ##
##  ------------------------------------------------------------------------  ##
##  pass options to free
alias meminfo='free -m -l -t'

##  Get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'

##  get top process eating cpu
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'

##  Get server cpu info
alias cpuinfo='lscpu'

##  ------------------------------------------------------------------------  ##
##                              Control Home Router                           ##
##  ------------------------------------------------------------------------  ##
##  Reboot home Linksys WAG160N / WAG54 / WAG320 / WAG120N Router / Gateway
# alias rebootlinksys="curl -u 'admin:super-pass' 'http://192.168.1.2/setup.cgi?todo=reboot'"

##  Reboot tomato based Asus NT16 wireless bridge
# alias reboottomato="ssh admin@192.168.1.1 /sbin/reboot"

##  ------------------------------------------------------------------------  ##
##          The 'ls' family (this assumes you use a recent GNU ls).           ##
##  ------------------------------------------------------------------------  ##
##  Add colors for filetype and human-readable sizes by default on 'ls':
alias ls='ls -hF --color'
alias lx='ls -lXB'                 #  Sort by extension.
alias lk='ls -lSr'                 #  Sort by size, biggest last.
alias lt='ls -ltr'                 #  Sort by date, most recent last.
alias lc='ls -ltcr'                #  Sort by/show change time,most recent last.
alias lu='ls -ltur'                #  Sort by/show access time,most recent last.

##  The ubiquitous 'll': directories first, with alphanumeric sorting:
alias ll='ls -lvF'
alias lm='ll | more'        #  Pipe through 'more'
alias lr='ll -R'            #  Recursive ls.
alias la='ll -A'            #  Show hidden files.
#alias tree='tree -Csuh'    #  Nice alternative to 'recursive ls' ...

##  file tree
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
##  file tree of directories only
alias dirtree="ls -R | grep :*/ | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'"

##  list folders by size in current directory
alias usage="du -h --max-depth=1 | sort -r"

##  ------------------------------------------------------------------------  ##
##                                  Some settings                             ##
##  ------------------------------------------------------------------------  ##
alias debug="set -o nounset; set -o xtrace"

##  ------------------------------------------------------------------------  ##
##          Enable color support of ls and also add handy aliases             ##
##  ------------------------------------------------------------------------  ##
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias dir='dir --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

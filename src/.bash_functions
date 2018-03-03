##		 ┌──────────────────────────────────────────────────────────────┐
##		 │  ____    _    ____  _   _       _____ ___ _     _____ ____   │
##		 │ | __ )  / \  / ___|| | | |     |  ___|_ _| |   | ____/ ___|  │
##		 │ |  _ \ / _ \ \___ \| |_| |_____| |_   | || |   |  _| \___ \  │
##		 │ | |_) / ___ \ ___) |  _  |_____|  _|  | || |___| |___ ___) | │
##		 │ |____/_/   \_\____/|_| |_|     |_|   |___|_____|_____|____/  │
##		 │                                                              │
##		 └──────────────────────────────────────────────────────────────┘
##  ------------------------------------------------------------------------  ##
##                               Helper Functions                             ##
##  ------------------------------------------------------------------------  ##

##  e.g., up -> go up 1 directory; up 4 -> go up 4 directories
function up () {
  dir=""
  if [[ $1 =~ ^[0-9]+$ ]]; then
    x=0
    while [ $x -lt ${1:-1} ];
      do
        dir=${dir}../
        x=$(($x+1))
      done
  else
    dir=..
  fi
  cd "$dir";
}

##  Function to run upon exit of shell.
# function _exit () {
    # echo -e "${BRed}Hasta la vista, ${BYellow}$USER${NC}";
# }
# trap _exit EXIT


##  ------------------------------------------------------------------------  ##
##                    Process/system related functions                        ##
##  ------------------------------------------------------------------------  ##

##  Get IP adress on ethernet/wi-fi
function iip () {
  local IP_LAN=$(/sbin/ifconfig eth0 | awk '/inet/ { print $2 }' | sed -e s/addr://) 2>/dev/null
  local IP_WAN=$(/sbin/ifconfig wlan0 | awk '/inet/ { print $2 }' | sed -e s/addr://) 2>/dev/null
  echo ${IP_LAN:-${IP_WAN:-"Not connected"}}
}

##  Get current host related info.
function ii () {
  echo -e "\n"
  echo -e "${BCyan}You are logged on:\t${NC} ${BYellow}$HOSTNAME${NC} as ${BYellow}$USER${NC} [${BWhite}$(if [ "root" = "$USER" ]; then echo $SUDO_USER; else echo $TERM; fi)${NC}]"
  echo -e "${BCyan}Host info:\t\t${NC} $(uname -a)"
  echo -e "${BCyan}Local IP Address:\t${NC} $(iip)"
  echo -e "\n${BBlue}Users logged on:${NC}"; w -hs | cut -d " " -f1 | sort | uniq
  echo -e "\n${BYellow}Machine stats:${NC}"; uptime
  echo -e "\n${BYellow}Memory stats:${NC}"; meminfo
  echo -e "\n${BYellow}Diskspace:${NC}"; df | grep "/dev/sd"
  echo -e "\n"
}
# echo -e "\n${BRed}Open connections:$NC"; netstat -apn --inet | grep ESTA;
# echo -e "\n${BRed}Current date:$NC"; date

##  Returns system load as percentage, i.e., '40' rather than '0.40)'.
function load () {
  ##  System load of the current host.
  local SYSLOAD=$(cut -d " " -f1 /proc/loadavg | tr -d '.')
  ##  Convert to decimal.
  echo $((10#$SYSLOAD))
}

##  Returns a color indicating system load.
function load_color () {
  local SYSLOAD=$(load)
  if [ ${SYSLOAD} -gt ${XLOAD} ]; then
    echo -en ${ALERT}
  elif [ ${SYSLOAD} -gt ${MLOAD} ]; then
    echo -en ${Red}
  elif [ ${SYSLOAD} -gt ${SLOAD} ]; then
    echo -en ${BRed}
  else
    echo -en ${Green}
  fi
}

##  Returns a color according to free disk space in $PWD.
function disk_color () {
  if [ ! -w "${PWD}" ]; then
    echo -en ${Red}               # No 'write' privilege in the current directory.
  elif [ -s "${PWD}" ]; then
    local used=$(command df -P "$PWD" | awk 'END {print $5} {sub(/%/,"")}')
    if [ ${used} -gt 95 ]; then
      echo -en ${ALERT}           # Disk almost full (>95%).
    elif [ ${used} -gt 90 ]; then
      echo -en ${BRed}            # Free disk space almost gone.
    else
      echo -en ${Green}           # Free disk space is ok.
    fi
  else
    echo -en ${Cyan}              # Current directory is size '0' (like /proc, /sys etc).
  fi
}

##  Returns a color according to running/suspended jobs.
function job_color () {
  if [ $(jobs -s | wc -l) -gt "0" ]; then
    echo -en ${BRed}
  elif [ $(jobs -r | wc -l) -gt "0" ] ; then
    echo -en ${BCyan}
  fi
}

##  Show top IPs extracted from provided log file
function visits () {
  local FILE="$1" ;
  echo "Top visitors from log file: [${FILE}]" ;
  sudo awk '{print $1}' ${FILE} | sort | uniq -c | sort -rn ;
}

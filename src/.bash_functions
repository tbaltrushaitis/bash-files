#!/usr/bin/env bash
##  ┌──────────────────────────────────────────────────────────────────┐
##  │  ____    _    ____  _   _           _____ ___ _     _____ ____   │
##  │ | __ )  / \  / ___|| | | |         |  ___|_ _| |   | ____/ ___|  │
##  │ |  _ \ / _ \ \___ \| |_| |  _____  | |_   | || |   |  _| \___ \  │
##  │ | |_) / ___ \ ___) |  _  | |_____| |  _|  | || |___| |___ ___) | │
##  │ |____/_/   \_\____/|_| |_|         |_|   |___|_____|_____|____/  │
##  │                                                                  │
##  └──────────────────────────────────────────────────────────────────┘
##  ------------------------------------------------------------------------  ##
##                                  Helpers                                   ##
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


# ##  Function to run upon exit of shell  ##
# function _exit () {
#   echo -e "\n\n\n";
#   echo -e "[${BWhite}$(date +'%F %T %Z')${NC}] Logout"
#   echo -e "\n\n\n";
#   echo -e "${BCyan}Hasta la vista, ${BYellow}${USER}${NC}!"
#   echo -e "\n\n\n";
# }
trap _exit EXIT


##  ------------------------------------------------------------------------  ##
##                    Process/system related functions                        ##
##  ------------------------------------------------------------------------  ##

##  IP adress on ethernet/wi-fi  ##
function iip () {
  local IP_LAN=$(/sbin/ifconfig eth0 2>/dev/null | awk '/inet/ { print $2 }' | sed -e s/addr://)
  local IP_WAN=$(/sbin/ifconfig wlan0 2>/dev/null | awk '/inet/ { print $2 }' | sed -e s/addr://)
  echo -e "${BYellow}${IP_LAN:-${IP_WAN:-'Not connected'}}${NC}"
}


##  Current host info  ##
function ii () {
  echo -e "${NC}"
  echo -e "${BCyan}You are logged on:\t${NC} ${BPurple}${HOSTNAME}${NC} as ${BYellow}$USER${NC} [${BWhite}$(if [ "root" = "${USER}" ]; then echo ${SUDO_USER}; else echo ${TERM}; fi)${NC}]"
  echo -e "${BCyan}Host info:\t\t${NC} ${BGreen}$(uname -nrvmo)${NC}"
  echo -e "${BCyan}Local IP Address:\t${NC} $(iip)"
  echo -e "${BCyan}Users logged on:${NC}\t [${BYellow}$(w -hs | cut -d " " -f1 | sort | uniq | paste -s -d' ')${NC}]"
  echo -e "\n${BCyan}Machine stats:${NC}"; uptime
  echo -e "\n${BCyan}Memory stats:${NC}"; meminfo
  echo -e "\n${BCyan}Diskspace:${NC}"; df | grep "/dev/sd"
  echo -e "\n"
}
# echo -e "\n${BRed}Current date:${NC}"; date


##  Network connections information  ##
function conns () {
  echo -e "\n${BBlue}Open connections:${NC}" ;
  netstat -apn --inet | grep ESTA ;
}


##  Returns system load as percentage, i.e., '40' rather than '0.40)'  ##
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
    local used=$(command df -P "${PWD}" | awk 'END {print $5} {sub(/%/,"")}')
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


##  Returns a color according to running/suspended jobs  ##
function job_color () {
  if [ $(jobs -s | wc -l) -gt "0" ]; then
    echo -en ${BRed}
  elif [ $(jobs -r | wc -l) -gt "0" ] ; then
    echo -en ${BCyan}
  fi
}


##  Show top IPs extracted from provided log file  ##
function visits () {
  local FILE="$1" ;
  local DT=$(date +'%F %T %Z');
  local PREF=$(date +'%Y%m%d_%H%M%S');
  local FILE_IPS="${PREF}_LATEST_VISITORS.log"
  local ITEMS=10;
  sudo awk '{print $1}' ${FILE} | sort | uniq -c | sort -rn | head -${ITEMS} > ${FILE_IPS} ;

  echo -e "[${BWhite}${DT}${NC}] ${BYellow}Top ${BGreen}${ITEMS}${NC} ${BYellow}visitors${NC} from log file [${BPurple}${FILE}${NC}]:" ;

  while read L;
    do
      local V_CNT=`echo ${L} | awk '{print $1}' | tr -d " "`
      local V_SRC=`echo ${L} | awk '{print $2}' | tr -d " "`
      echo -e "[${BYellow}${V_CNT}${NC}] -> [${BCyan}${V_SRC}${NC}]:"
      whois ${V_SRC} | grep -e "address:" -e "country:" --max-count=5
    done < ${FILE_IPS}

}


##  Remove comments (lines started with '#') from file  ##
function stripcomments () {
  local FILE="$1";
  if [ ! -z "${FILE}" ] && [ -f "${FILE}" ]; then
    sed -i '/^#/d' "${FILE}" ;
    echo -e "[${BWhite}$(date +'%F %T %Z')${NC}] ${Yellow}Comments removed from file${NC}: [${BBlue} ${FILE} ${NC}]";
  fi;
}


##  FIX Windows CRLF to Unix LF  ##
function cr2lf () {
  local FILE="$1";
  if [ ! -z "${FILE}" ] && [ -f "${FILE}" ]; then
    sed -i 's/\r$//' "${FILE}" ;
    echo -e "[${BWhite}$(date +'%F %T %Z')${NC}] ${Yellow}(CRLF)${NC} Changed to ${Yellow}(LF)${NC} in: [${BPurple} ${FILE} ${NC}]";
  fi;
}

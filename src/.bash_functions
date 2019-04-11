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


##  ------------------------------------------------------------------------  ##
##                    Process/system related functions                        ##
##  ------------------------------------------------------------------------  ##

##  IP adress on ethernet/wi-fi  ##
function iip () {
  local IP_LAN=$(/sbin/ifconfig eth0 2>/dev/null | awk '/inet/ { print $2 }' | sed -e s/addr://)
  local IP_WAN=$(/sbin/ifconfig wlan0 2>/dev/null | awk '/inet/ { print $2 }' | sed -e s/addr://)
  echo -e "${BYellow}${IP_LAN:-${IP_WAN:-'Not connected'}}${NC}"
}


##  ------------------------------------------------------------------------  ##
##                           Current host info                                ##
##  ------------------------------------------------------------------------  ##

function ii () {
  echo -e "${NC}";
  echo -e "${BCyan}You are logged on:\t${NC} ${BPurple}${HOSTNAME}${NC} as ${BYellow}$USER${NC} [${BWhite}$(if [ "root" = "${USER}" ]; then echo ${SUDO_USER}; else echo ${TERM}; fi)${NC}]"
  echo -e "${BCyan}Host info:\t\t${NC} ${BGreen}$(uname -nrvmo)${NC}"
  echo -e "${BCyan}Local IP Address:\t${NC} $(iip)"
  echo -e "${BCyan}Users logged on:${NC}\t [${BYellow}$(w -hs | cut -d " " -f1 | sort | uniq | paste -s -d' ')${NC}]"
  echo -e "\n${BCyan}Machine stats:${NC}"; uptime
  echo -e "\n${BCyan}Memory stats:${NC}"; meminfo
  echo -e "\n${BCyan}Diskspace:${NC}"; df | grep "/dev/sd"
  echo -e "\n";
}


##  ------------------------------------------------------------------------  ##
##                      Network connections information                       ##
##  ------------------------------------------------------------------------  ##

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


##  ------------------------------------------------------------------------  ##
##                Show top IPs extracted from provided log file               ##
##  ------------------------------------------------------------------------  ##

function visits () {
  if [ -z "$1" ]; then
    echo -e "\nUsage:\n\n ${Yellow}${FUNCNAME}${NC} <LOG_FILE> [COUNT]\n" ;
    return 1 ;
  fi
  local FILE_LOG="$1";
  local ITEMS=${2:-10};
  local PREF=$(date +'%Y%m%d_%H%M%S');
  local FILE_IPS="/tmp/${PREF}_LATEST_VISITORS.log";

  sudo awk '{print $1}' ${FILE_LOG} | sort | uniq -c | sort -rn | head -${ITEMS} > ${FILE_IPS} ;

  echo -e "[${BWhite}$(date +'%F %T %Z')${NC}] Top [${BYellow}${ITEMS}${NC}] visitors from log file [${BPurple}${FILE_LOG}${NC}]:" ;
  while read L;
    do
      local V_CNT=`echo ${L} | awk '{print $1}' | tr -d " "` ;
      local V_SRC=`echo ${L} | awk '{print $2}' | tr -d " "` ;
      echo -e "[${BYellow}${V_CNT}${NC}] -> [${BCyan}${V_SRC}${NC}]:" ;
      whois ${V_SRC} | grep -e "[A\|a]ddress:" -e "[C\|c]ountry:" -e "Organization" --max-count=5 ;
    done < ${FILE_IPS}
}


##  ------------------------------------------------------------------------  ##
##              Remove comments (lines started with '#') from file            ##
##  ------------------------------------------------------------------------  ##

function stripcomments () {
  local FILE="$1";
  if [ ! -z "${FILE}" ] && [ -f "${FILE}" ]; then
    sed -r "/^(#|$)/d" -i "${FILE}" ;
    echo -e "[${BWhite}$(date +'%F %T %Z')${NC}] ${Yellow}Comments removed${NC} from file: [${BPurple}${FILE}${NC}]" ;
  else
    echo -e "\nUsage:\n\n ${Yellow}${FUNCNAME}${NC} <FILE>\n" ;
  fi;
}


##  ------------------------------------------------------------------------  ##
##                          FIX Windows CRLF to Unix LF                       ##
##  ------------------------------------------------------------------------  ##

function cr2lf () {
  local FILE="$1";
  if [ ! -z "${FILE}" ] && [ -f "${FILE}" ]; then
    sed -i 's/\r$//' "${FILE}" ;
    echo -e "[${BWhite}$(date +'%F %T %Z')${NC}] Changed ${Yellow}(CRLF)${NC} to ${Yellow}(LF)${NC} in: [${BPurple}${FILE}${NC}]" ;
  else
    echo -e "\nUsage:\n\n ${Yellow}${FUNCNAME}${NC} <FILE>\n" ;
  fi;
}


##  ------------------------------------------------------------------------  ##
##                   Replace spaces in file name with dashes                  ##
##  ------------------------------------------------------------------------  ##

function unspace () {
  local FILE="$1";
  if [ ! -z "${FILE}" ] && [ -f "${FILE}" ]; then
    local NEW_NAME=$(echo ${FILE} | tr "[:blank:]" "-") ;
    mv "${FILE}" "${NEW_NAME}" ;
    echo -e "[${BWhite}$(date +'%F %T %Z')${NC}] RENAMED [${Yellow}${FILE}${NC}] to [${Purple}${NEW_NAME}${NC}]" ;
  else
    echo -e "\nUsage:\n\n ${Yellow}${FUNCNAME}${NC} \"<FILE>\"\n" ;
  fi;
}

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

##  IP address on ethernet/wi-fi  ##
function iip () {
  local IP_LAN=$(/sbin/ifconfig eth0 2>/dev/null | awk '/inet/ { print $2 }' | sed -e s/addr://)
  local IP_WAN=$(/sbin/ifconfig wlan0 2>/dev/null | awk '/inet/ { print $2 }' | sed -e s/addr://)
  echo -e "${Yellow}${IP_LAN:-${IP_WAN:-'Not connected'}}${NC}"
}


##  ------------------------------------------------------------------------  ##
##                           Current host info                                ##
##  ------------------------------------------------------------------------  ##

function ii () {
  echo -e "${NC}";
  echo -e "${Cyan}You are logged on:\t${NC} ${Purple}$(hostname)${NC} as ${Orange}$USER${NC} [${White}$(if [ "root" = "${USER}" ]; then echo ${SUDO_USER}; else echo ${TERM}; fi)${NC}]"
  echo -e "${Cyan}Host info:\t\t${NC} ${Green}$(uname -nrvmo)${NC}"
  echo -e "${Cyan}Local IP Address:\t${NC} $(iip)"
  echo -e "${Cyan}Users logged on:${NC}\t [${Yellow}$(w -hs | cut -d " " -f1 | sort | uniq | paste -s -d' ')${NC}]"
  echo -e "\n${Cyan}Machine stats:${NC}"; uptime
  echo -e "\n${Cyan}Memory stats:${NC}"; meminfo
  echo -e "\n${Cyan}Diskspace:${NC}"; df | grep -E "/dev/(.)?d"
  echo -e "\n";
}


##  ------------------------------------------------------------------------  ##
##                      Network connections information                       ##
##  ------------------------------------------------------------------------  ##

function conns () {
  echo -e "\n${Blue}Open connections:${NC}" ;
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
    echo -e "\n${Blue}Show top IPs extracted from provided log file${NC}" ;
    echo -e "\nUsage:\n\n ${Yellow}${FUNCNAME}${NC} <LOG_FILE> [COUNT]\n" ;
    return 1 ;
  fi
  local FILE_LOG="$1";
  local ITEMS=${2:-10};
  local PREF=$(date +'%Y%m%d_%H%M%S');
  local FILE_IPS="/tmp/${PREF}_LATEST_VISITORS.log";

  sudo awk '{print $1}' ${FILE_LOG} | sort | uniq -c | sort -rn | head -${ITEMS} > ${FILE_IPS} ;

  echo -e "[${White}$(date +'%F %T %Z')${NC}] Top [${Yellow}${ITEMS}${NC}] visitors from log file [${Purple}${FILE_LOG}${NC}]:" ;
  while read L;
    do
      local V_CNT=`echo ${L} | awk '{print $1}' | tr -d " "` ;
      local V_SRC=`echo ${L} | awk '{print $2}' | tr -d " "` ;
      echo -e "[${Yellow}${V_CNT}${NC}] -> [${Cyan}${V_SRC}${NC}]:" ;
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
    echo -e "[${White}$(date +'%F %T %Z')${NC}] ${Yellow}Comments removed${NC} from file: [${Purple}${FILE}${NC}]" ;
  else
    echo -e "\n${Blue}Remove comments (lines started with '#') from file${NC}" ;
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
    echo -e "[${White}$(date +'%F %T %Z')${NC}] Changed ${Yellow}(CRLF)${NC} to ${Yellow}(LF)${NC} in: [${Purple}${FILE}${NC}]" ;
  else
    echo -e "\n${Blue}FIX Windows CRLF to Unix LF${NC}" ;
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
    echo -e "[${White}$(date +'%F %T %Z')${NC}] RENAMED [${Yellow}${FILE}${NC}] to [${Purple}${NEW_NAME}${NC}]" ;
  else
    echo -e "\n${Yellow}Replace spaces in file name with dashes${NC}" ;
    echo -e "\nUsage:\n\n ${Yellow}${FUNCNAME}${NC} \"<FILE>\"\n" ;
  fi;
}


##  ------------------------------------------------------------------------  ##
##                               Show help topic                              ##
##  ------------------------------------------------------------------------  ##

function bfiles_help () {

  if [ -f "${APP_LOGO}" ]; then cat "${APP_LOGO}"; fi ;

  echo -e "${Cyan}---------------------------------------------------------------${NC}";
  echo -e "${BYellow}${On_Blue}bash-files${NC} - Stack of useful .bashrc configs for Linux shell";
  echo -e "${Purple}https://github.com/tbaltrushaitis/bash-files${NC}";
  echo -e "(C) 2018-present Baltrushaitis Tomas <tbaltrushaitis@gmail.com>";
  echo -e "${Cyan}---------------------------------------------------------------${NC}";
  echo -e "${Gold}Available commands${NC}:";
  echo -e "\t ${Yellow}ii${NC} \t\t - Current host info";
  echo -e "\t ${Yellow}iip${NC} \t\t - ${White}IP address${NC} on ethernet/wi-fi";
  echo -e "\t ${Yellow}conns${NC} \t\t - Show open connections";
  echo -e "\t ${Yellow}visits${NC} \t - Show ${White}top IPs${NC} extracted from provided log file";
  echo -e "\t ${Yellow}stripcomments${NC} \t - ${Red}Remove comments${NC} from file";
  echo -e "\t ${Yellow}cr2lf${NC} \t\t - FIX Windows ${White}CRLF${NC} to Unix ${Cyan}LF${NC}";
  echo -e "\t ${Yellow}unspace${NC} \t - Replace ${White}spaces${NC} in file name with ${Cyan}dashes${NC}";
  echo -e "\t ${Yellow}pwg${NC} \t\t - Generates strong 32-byte ${White}password${NC}";
  echo -e "\t ${Yellow}mkd${NC} \t\t - Create a new ${White}directory${NC} and enter it";
  echo -e "${Cyan}---------------------------------------------------------------${NC}";

}

##  ------------------------------------------------------------------------  ##
##                    Create a new directory and enter it                     ##
##  ------------------------------------------------------------------------  ##

function mkd () {
  mkdir -p "$@" && cd "$_";
}

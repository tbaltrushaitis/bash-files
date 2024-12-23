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
##  ------------------------------  DATETIME  ------------------------------  ##
function DT () {
  printf "[${Gray}$(date +'%T')${NC}]"
}

function TT () {
  printf "[${Gray}$(date +'%T')${NC}]"
}


##  ------------------------------------------------------------------------  ##
##        e.g., up -> go up 1 directory; up 4 -> go up 4 directories          ##
##  ------------------------------------------------------------------------  ##
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
  local IP_ENP=$(/sbin/ifconfig enp1s0 2>/dev/null | awk '/inet/ { print $2 }' | sed -e s/addr://)
  echo -e "${Yellow}${IP_LAN:-${IP_WAN:-${IP_ENP:-'Not connected'}}}${NC}"
}


##  ------------------------------------------------------------------------  ##
##                           Current host info                                ##
##  ------------------------------------------------------------------------  ##
function ii () {
  bf_banner;
  echo -e "${NC}";
  echo -e "${Cyan}You are logged on${NC}:\t ${Red}$(hostname -f)${NC} as ${BYellow}${On_Blue}$USER${NC}$(if [ "root" = "${USER}" ]; then echo "(${Yellow}${SUDO_USER}${NC})"; fi) in [${BBlue}${TERM}${NC}] at [${Cyan}TTY${NC}:${Yellow}$(tty)${NC}]"
  echo -e "${Cyan}Host info${NC}:\t\t [${White}$(uname -rvmo)${NC}]"
  echo -e "${Cyan}Local IP Address${NC}(es):\t $(iip)"
  echo -e "${Cyan}Users logged on${NC}:\t [${BYellow}$(w -hs | cut -d " " -f1 | sort | uniq | paste -s -d' ')${NC}]"
  echo -e "\n${Cyan}Uptime${NC}:\t\t\t [${White}$(uptime)${NC} ]"
  echo -e "\n${Cyan}Memory stats${NC}: [\n${White}$(meminfo)${NC}\n]"
  echo -e "\n${Cyan}Diskspace${NC}:"; df | grep --color -E "/dev/(.)?d"
  echo -e "\n";
}


##  ------------------------------------------------------------------------  ##
##                      Network connections information                       ##
##  ------------------------------------------------------------------------  ##
function conns () {
  echo -e "${Gold}Active connections${NC}:" ;
  netstat -apn --inet | grep ESTA ;
}


##  ------------------------------------------------------------------------  ##
##      Returns system load as percentage, i.e., '40' rather than '0.40)'     ##
##  ------------------------------------------------------------------------  ##
function load () {
  ##  System load of the current host
  local SYSLOAD=$(cut -d " " -f1 /proc/loadavg | tr -d '.')
  ##  Convert to decimal
  echo $((10#$SYSLOAD))
}


##  ------------------------------------------------------------------------  ##
##                    Returns a color indicating system load                  ##
##  ------------------------------------------------------------------------  ##
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


##  ------------------------------------------------------------------------  ##
##            Returns a color according to free disk space in $PWD            ##
##  ------------------------------------------------------------------------  ##
function disk_color () {
  if [ ! -w "${PWD}" ]; then
    echo -en ${Red}       # No 'write' privilege in the current directory
  elif [ -s "${PWD}" ]; then
    local used=$(command df -P "${PWD}" | awk 'END {print $5} {sub(/%/,"")}')
    if [ ${used} -gt 95 ]; then
      echo -en ${ALERT}   # Disk almost full (>95%).
    elif [ ${used} -gt 90 ]; then
      echo -en ${BRed}    # Free disk space almost gone
    else
      echo -en ${Green}   # Free disk space is ok
    fi
  else
    echo -en ${Cyan}      # Current directory is size '0' (like /proc, /sys etc)
  fi
}


##  ------------------------------------------------------------------------  ##
##              Returns a color according to running/suspended jobs           ##
##  ------------------------------------------------------------------------  ##
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
    echo -e "\n${Cyan}Show top IPs extracted from provided log file${NC}" ;
    echo -e "\nUsage:\n\n  ${Yellow}${FUNCNAME}${NC} <LOG_FILE> [COUNT=5]\n" ;
    return 1 ;
  fi
  local FILE_LOG="$1";
  local ITEMS=${2:-5};
  local PREF=$(date +'%Y%m%d_%H%M%S');
  local FILE_IPS="/tmp/${PREF}_LATEST_VISITORS.log";

  sudo awk '{print $1}' ${FILE_LOG} | sort | uniq -c | sort -rn | head -${ITEMS} > ${FILE_IPS} ;

  echo -e "[${Gray}$(date +'%T')${NC}] Top [${Yellow}${ITEMS}${NC}] visitors from log file [${Purple}${FILE_LOG}${NC}]:" ;
  while read L;
    do
      local V_CNT=`echo ${L} | awk '{print $1}' | tr -d " "` ;
      local V_SRC=`echo ${L} | awk '{print $2}' | tr -d " []"` ;
      echo -e "[${Yellow}${V_CNT}${NC}] -> [${Cyan}${V_SRC}${NC}]:" ;
      whois ${V_SRC} | grep -e "^[A\|a]ddress:" -e "^[C\|c]ountry:" -e "^[O\|o]rganization" --max-count=5 ;
    done < ${FILE_IPS}
}


##  ------------------------------------------------------------------------  ##
##              Remove comments (lines started with '#') from file            ##
##  ------------------------------------------------------------------------  ##
function stripcomments () {
  local FILE="$1";
  if [ ! -z "${FILE}" ] && [ -f "${FILE}" ]; then
    sed -r "/^(#|$)/d" -i "${FILE}" ;
    echo -e "[${Gray}$(date +'%T')${NC}] ${Yellow}Comments removed${NC} from file: [${Purple}${FILE}${NC}]" ;
  else
    echo -e "\n${Cyan}Remove comments (lines started with '#') from file${NC}" ;
    echo -e "\nUsage:\n\n  ${Yellow}${FUNCNAME}${NC} <FILE>\n" ;
  fi;
}


##  ------------------------------------------------------------------------  ##
##                          FIX Windows CRLF to Unix LF                       ##
##  ------------------------------------------------------------------------  ##
function cr2lf () {
  local FILE="$1";
  if [ ! -z "${FILE}" ] && [ -f "${FILE}" ]; then
    sed -i 's/\r$//' "${FILE}" ;
    echo -e "[${Gray}$(date +'%T')${NC}] Changed ${Yellow}(CRLF)${NC} to ${Yellow}(LF)${NC} in: [${Purple}${FILE}${NC}]" ;
  else
    echo -e "\n${Cyan}FIX Windows CRLF to Unix LF${NC}" ;
    echo -e "\nUsage:\n\n  ${Yellow}${FUNCNAME}${NC} <FILE>\n" ;
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
    echo -e "[${Gray}$(date +'%T')${NC}] RENAMED [${Yellow}${FILE}${NC}] to [${Purple}${NEW_NAME}${NC}]" ;
  else
    echo -e "\n${Cyan}Replace spaces with dashes in given file name${NC}" ;
    echo -e "\nUsage:\n\n  ${Yellow}${FUNCNAME}${NC} <FILE>\n" ;
  fi
}


##  ------------------------------------------------------------------------  ##
##                               Show help topic                              ##
##  ------------------------------------------------------------------------  ##
function bfiles_help () {

  bf_banner;

  echo -e "${Cyan}---------------------------------------------------------------${NC}"
  echo -e "${Yellow}${On_Blue}bash-files${NC} - Stack of useful .bashrc configs for Linux shell"
  echo -e "${Cyan}https://github.com/tbaltrushaitis/bash-files${NC}"
  echo -e "(C) 2018-present Baltrushaitis Tomas <${White}tbaltrushaitis@gmail.com${NC}>"
  echo -e "${Cyan}---------------------------------------------------------------${NC}"
  echo -e "${Gold}Available commands${NC}:"
  echo -e "\t ${Green}ii${NC} \t\t - Host information"
  echo -e "\t ${Green}iip${NC} \t\t - ${White}IP address${NC} on ethernet/wi-fi"
  echo -e "\t ${Green}conns${NC} \t\t - Show ESTABLISHED connections"
  echo -e "\t ${BGreen}stripcomments${NC} \t - ${Red}Remove${NC} lines, starts with ${White}#${NC} (commented)"
  echo -e "\t ${BGreen}cr2lf${NC} \t\t - FIX Windows ${White}CRLF${NC} to Unix ${Cyan}LF${NC}"
  echo -e "\t ${BGreen}unspace${NC} \t - Replace ${White}spaces${NC} in file name with ${Cyan}dashes${NC}"
  echo -e "\t ${BGreen}pwg${NC} \t\t - Generates strong 32-byte ${White}password${NC}"
  echo -e "\t ${BGreen}mkd${NC} \t\t - Create a new ${White}directory${NC} and ${White}enter${NC} it"
  echo -e "\t ${BGreen}ports${NC} \t\t - Show ports that OS is currently LISTEN to"
  echo -e "\t ${Yellow}psnode${NC} \t - Show ${White}node.js${NC} processes"
  echo -e "\t ${Yellow}psport${NC} \t - Show processes on given ${White}PORT${NC}"
  echo -e "\t ${Yellow}k9p${NC} \t\t - Kill process on given ${White}PORT${NC}"
  echo -e "\t ${Yellow}npmi${NC} \t\t - Install provided NPM package (if any) or from ${White}package.json${NC} otherwise"
  echo -e "\t ${BGreen}visits${NC} \t - Show ${White}top IPs${NC} extracted from provided log file"
  echo -e "${Cyan}---------------------------------------------------------------${NC}"

}


##  ------------------------------------------------------------------------  ##
##                    Create a new directory and enters it                    ##
##  ------------------------------------------------------------------------  ##
function mkd () {
  mkdir -p "$@" && cd "$_"
}


##  ------------------------------------------------------------------------  ##
##                         Create /etc/banner                                 ##
##  ------------------------------------------------------------------------  ##
function gen_etc_banner () {
  local SLOG=${1:${APP_NAME}}
  sudo figlet-toilet  \
    --termwidth       \
    --font standard   \
    --filter border   \
    --filter gay      \
    $(shell echo '"' ${APP_SLOG} '"' | tr [:lower:] [:upper:]) \
    --export "utf8"   \
    > ${APP_LOGO}     \
  ;
}


##  ------------------------------------------------------------------------  ##
##                          Print bash-files banner                           ##
##  ------------------------------------------------------------------------  ##
function bf_banner () {
  local BF_LOGO=/usr/etc/.bash_files/assets/BANNER
  if [ -f "${BF_LOGO}" ]; then
    cat "${BF_LOGO}"
  else
    echo "BANNER file [${BF_LOGO}] is NOT FOUND"
  fi
}


##  ------------------------------------------------------------------------  ##
##                          Show Node.js processes                            ##
##  ------------------------------------------------------------------------  ##
function psnode () {
  local PORT=${1}
  echo -e "${Gold}Node processes${NC}:" ;
  ps -fax | grep node
  echo -e "\n${Gold}Node processes on ports${NC}:" ;
  netstat -tulanp | grep node
}


##  ------------------------------------------------------------------------  ##
##                          Show process on port                              ##
##  ------------------------------------------------------------------------  ##
function psport () {
  local PORT=${1}
  if [ ! -z ${PORT} ]; then
    echo -e "\n${Gold}Processes on port [${PORT}]${NC}:" ;
    ps -x | tail -n +2 | grep "${PORT}" | awk '{print $1}'
  fi
}

function k9p () {
  local PORT=${1}
  local PID=`psport ${PORT}`
  if [ ! -z ${PID} ]; then
    echo -e "\n${Gold}Kill process [${PID}]${NC}:" ;
    kill -9 ${PID}
  fi
}


##  ------------------------------------------------------------------------  ##
##                      Install Node.js package(s)                            ##
##  ------------------------------------------------------------------------  ##
function npmi () {
  local pkg="$@"
  if [ -z ${pkg} ]; then
    echo -ne "\nInstalling ${Cyan}all packages${NC} from ${White}package.json${NC}\n\n"
    npm i
    cat package.json
  else
    local pkg_name=$(echo ${pkg} | cut -d@ -f1)
    echo -ne "\nInstalling package: \t ${White}${pkg}${NC}\n\n"
    npm i --save ${pkg}
    npm info ${pkg_name}
    grep "${pkg_name}" package.json
  fi
}

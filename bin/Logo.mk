##  ------------------------------------------------------------------------  ##
##                        Create application BANNER                           ##
##  ------------------------------------------------------------------------  ##

FIGLET := figlet-toilet --termwidth --font standard --filter border --filter gay
BTEXT  := $(shell echo \' ${APP_SLOG} \' | tr [:lower:] [:upper:] ;)

.PHONY: logo

logo:
	@ echo "${BCyan}-------------------------------------------------------------${NC}";
	@ $(shell $(FIGLET) $(BTEXT) --export "utf8" > "${APP_LOGO}")
	@ echo "${BYellow}Created${NC}: [${BPurple}${APP_LOGO}${NC}]" ;
	@ $(shell $(FIGLET) $(BTEXT) --export "utf8" > "${APP_LOGO}.txt")
	@ echo "${BYellow}Created${NC}: [${BPurple}${APP_LOGO}.txt${NC}]" ;
	@ $(shell $(FIGLET) $(BTEXT) --export "html" > "${APP_LOGO}.html")
	@ echo "${BYellow}Created${NC}: [${BPurple}${APP_LOGO}.html${NC}]" ;
	@ $(shell $(FIGLET) $(BTEXT) --export "svg" > "${APP_LOGO}.svg")
	@ echo "${BYellow}Created${NC}: [${BPurple}${APP_LOGO}.svg${NC}]" ;
	@ echo "[${BWhite}$(shell date +'%F %T %Z')${NC}] ${Yellow}DONE${NC}: [${BYellow}${On_Blue}$@${NC}]" ;
	@ echo "\n ${BYellow}LOGO${NC} Operation ${BYellow}${On_Blue}COMPLETED${NC} \n" ;
	@ echo "${BCyan}-------------------------------------------------------------${NC}";
	@ if [ -f "${APP_LOGO}" ]; then cat "${APP_LOGO}"; fi;

##  ------------------------------------------------------------------------  ##

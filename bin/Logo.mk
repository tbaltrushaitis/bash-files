##  ------------------------------------------------------------------------  ##
##                        Create application BANNER                           ##
##  ------------------------------------------------------------------------  ##

FIGLET := figlet-toilet --termwidth --font standard --filter border --filter gay
BTEXT  := $(shell echo \' ${APP_SLOG} \' | tr [:lower:] [:upper:] ;)

.PHONY: logo

logo:
	@ echo "${BCyan}-------------------------------------------------------------${NC}";
	@ $(shell $(FIGLET) $(BTEXT) --export "utf8" > "${APP_LOGO}")
	@ echo "$(DAT) ${BYellow}Created${NC}: [${BPurple}${APP_LOGO}${NC}]" ;
	@ $(shell $(FIGLET) $(BTEXT) --export "utf8" > "${APP_LOGO}.txt")
	@ echo "$(DAT) ${BYellow}Created${NC}: [${BPurple}${APP_LOGO}.txt${NC}]" ;
	@ $(shell $(FIGLET) $(BTEXT) --export "html" > "${APP_LOGO}.html")
	@ echo "$(DAT) ${BYellow}Created${NC}: [${BPurple}${APP_LOGO}.html${NC}]" ;
	@ $(shell $(FIGLET) $(BTEXT) --export "svg" > "${APP_LOGO}.svg")
	@ echo "$(DAT) ${BYellow}Created${NC}: [${BPurple}${APP_LOGO}.svg${NC}]" ;
	@ echo "$(DAT) $(DONE): $(TARG)" ;
	@ echo "\n$(DAT) [${BYellow}LOGO${NC}] Operation ${BYellow}${On_Blue}COMPLETED${NC} \n" ;
	@ echo "${BCyan}-------------------------------------------------------------${NC}";
	@ if [ -f "${APP_LOGO}" ]; then cat "${APP_LOGO}"; fi;

##  ------------------------------------------------------------------------  ##

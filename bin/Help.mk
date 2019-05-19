##  ------------------------------------------------------------------------  ##
##                              Show help topic                               ##
##  ------------------------------------------------------------------------  ##

.PHONY: help

help: banner
	@ echo "${Cyan}--------------------------------------------------------${NC}";
	@ echo "${Orange}Available commands${NC}:";
	@ echo "\t make \t\t - Run ${White}default${NC} task";
	@ echo "\t make ${Cyan}help${NC} \t - Usage info";
	@ echo "\t make ${Cyan}clean${NC} \t - Clear directories and delete files";
	@ echo "\t make ${Cyan}setup${NC} \t - Setup environment";
	@ echo "\t make ${Cyan}deploy${NC} \t - Deploy project files";
	@ echo "\t make ${Cyan}all${NC} \t - Run ${White}all${NC} defined tasks";
	@ echo "${Cyan}--------------------------------------------------------${NC}";

##  ------------------------------------------------------------------------  ##

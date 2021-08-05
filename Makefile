##  ------------------------------------------------------------------------  ##
##
##  ┌──────────────────────────────────────────────────────────────────┐
##  │  ____    _    ____  _   _           _____ ___ _     _____ ____   │
##  │ | __ )  / \  / ___|| | | |         |  ___|_ _| |   | ____/ ___|  │
##  │ |  _ \ / _ \ \___ \| |_| |  _____  | |_   | || |   |  _| \___ \  │
##  │ | |_) / ___ \ ___) |  _  | |_____| |  _|  | || |___| |___ ___) | │
##  │ |____/_/   \_\____/|_| |_|         |_|   |___|_____|_____|____/  │
##  │                                                                  │
##  └──────────────────────────────────────────────────────────────────┘
##
##  ------------------------------------------------------------------------  ##

.SILENT:
.EXPORT_ALL_VARIABLES:
.IGNORE:
.ONESHELL:

SHELL = /bin/sh
THIS_FILE := $(lastword $(MAKEFILE_LIST))
TO_NULL = 2>&1 >/dev/null

# $(info [THIS_FILE:$(Blue)$(THIS_FILE)$(NC)])

##  ------------------------------------------------------------------------  ##

APP_NAME := bash-files
APP_PREF := bash_files
APP_SLOG := "BASH - FILES"
APP_LOGO := ./assets/BANNER
APP_REPO := $(shell git ls-remote --get-url)
APP_HOST := $(shell hostname -s  | tr [:lower:] [:upper:] )

DT = $(shell date +'%T')
TS = $(shell date +'%s')
WD := $(shell pwd -P)
BD := $(WD)/bin

DAT = [$(Gray)$(DT)$(NC)]
SRC := $(WD)/src
DST := /usr/etc/.$(APP_PREF)
BST := $(realpath $(HOME))

$(shell [ -d $(DST) ] || sudo mkdir -p "$(DST)" && sudo chown -R ${USER}:$(id -gn ${USER}) "$(DST)" && sudo chmod 775 "$(DST)");

##  ------------------------------------------------------------------------  ##
include $(BD)/Colors
##  ------------------------------------------------------------------------  ##

LN := ln -sf --backup=simple
CP := cp -prf --backup=simple
MV := mv -f
# --backup=numbered

DONE = $(Yellow)DONE$(NC)
FINE = $(Yellow)$(On_Green)FINISHED$(NC)
TARG = [$(Yellow)$(On_Blue) $@ $(NC)]
THIS = [$(Red)$(THIS_FILE)$(NC)]

##  ------------------------------------------------------------------------  ##
DOTFILES := $(notdir $(wildcard $(SRC)/.??*))
ROOTFILES := $(notdir $(wildcard $(SRC)/root/.??*))
##  ------------------------------------------------------------------------  ##

$(info $(DAT) $(Orange)RUN$(NC):      $(THIS));
$(info $(DAT) $(Orange)USR$(NC):      [$(Yellow)$(USER)$(NC)]);
$(info $(DAT) $(Orange)SRC$(NC):      [$(Cyan)$(SRC)$(NC)]);
$(info $(DAT) $(Orange)DST$(NC):      [$(Purple)$(DST)$(NC)]);
$(info $(DAT) $(Orange)BST$(NC):      [$(Purple)$(BST)$(NC)]);
$(info $(DAT) $(Orange)APP_HOST$(NC): [$(Red)$(APP_HOST)$(NC)]);
$(info $(DAT) $(Cyan)FILES$(NC));
$(info $(DAT)   \-- $(Yellow)USER$(NC): [$(White)$(DOTFILES)$(NC)]);
$(info $(DAT)   \-- $(Yellow)ROOT$(NC): [$(White)$(ROOTFILES)$(NC)]);

##  ------------------------------------------------------------------------  ##
# That's our default target when none is given on the command line
PHONY := _default _all

_default: _all ;
	@ echo "$(DAT) $(DONE): $(TARG)"

##  ------------------------------------------------------------------------  ##
##  Query default goal
##  ------------------------------------------------------------------------  ##
ifeq ($(.DEFAULT_GOAL),)
.DEFAULT_GOAL := _default
endif
$(info $(DAT) $(Cyan)GOALS$(NC));
$(info $(DAT)   \-- $(Yellow)DEFAULT$(NC): [$(White)$(.DEFAULT_GOAL)$(NC)]);
$(info $(DAT)   \-- $(Yellow)CURRENT$(NC): [$(Purple)$(MAKECMDGOALS)$(NC)]);


##  ------------------------------------------------------------------------  ##
##                                  INCLUDES                                  ##
##  ------------------------------------------------------------------------  ##
include $(BD)/*.mk

##  ------------------------------------------------------------------------  ##
##  Setup packages used by project commands
PHONY += setup-deps

setup-deps:;
	@ sudo apt-get -qq -y install pwgen figlet toilet toilet-fonts
	@ echo "$(DAT) $(DONE): $(TARG)"


##  ------------------------------------------------------------------------  ##
##  Create host banner in /etc/banner (show on login via ssh protocol)
PHONY += create-host-banner

create-host-banner: ;
	@ sudo cp /etc/banner "/etc/banner.${TS}" 2>/dev/null
	@ sudo chmod 664 /etc/banner
	@ sudo figlet-toilet --termwidth --font big --filter border "$(APP_HOST)" --export "utf8" > /etc/banner
	@ echo "$(DAT) $(DONE): $(TARG)"


##  ------------------------------------------------------------------------  ##
PHONY += setup

setup: setup-deps create-host-banner ;
	@ $(shell [ -d "$(DST)" ] || sudo mkdir -p "$(DST)" && sudo chown -R "$(USER)":$(id -gn ${USER}) "$(DST)" && sudo chmod 775 "$(DST)")
	@ echo "$(DAT) $(DONE): $(TARG)"


##  ------------------------------------------------------------------------  ##
PHONY += post-install-msg

post-install-msg:;
	@ echo "$(DAT) Installation $(FINE)"
	@ echo ""
	@ echo "###################################################################"
	@ echo "#                                                                 #"
	@ echo "#                                                                 #"
	@ echo "#                   C   A   U   T   I   O   N                     #"
	@ echo "#                                                                 #"
	@ echo "#          This is first start of ${White}BASH-FILES${NC} installer.           #"
	@ echo "#     You MUST ${Yellow}${On_Red}restart shell${NC} to have ${Orange}new settings${NC} effective.      #"
	@ echo "#                                                                 #"
	@ echo "#                                                                 #"
	@ echo "###################################################################"
	@ echo ""

##  ------------------------------------------------------------------------  ##
PHONY += deploy deploy-assets deploy-dot-files deploy-links deploy-root-files

deploy-assets:;
	@ $(CP) "$(WD)/assets" "$(DST)/"
	@ echo "$(DAT) $(DONE): $(TARG)"

deploy-dot-files:;
	@ $(foreach val, $(DOTFILES), $(CP) "$(SRC)/$(val)" "$(DST)/" ;)
	@ echo "$(DAT) $(DONE): $(TARG)"

deploy-links:;
	@ $(foreach val, $(DOTFILES), sudo $(LN) "$(DST)/$(val)" "$(BST)/" ;)
	@ $(foreach val, $(DOTFILES), sudo $(LN) "$(DST)/$(val)" "/root/" ;)
	@ echo "$(DAT) $(DONE): $(TARG)"

deploy-root-files:;
	@ $(foreach val, $(ROOTFILES), sudo $(CP) "$(SRC)/root/$(val)" "/root/" ;)
	@ echo "$(DAT) $(DONE): $(TARG)"

deploy: deploy-assets deploy-dot-files deploy-links deploy-root-files ;
	@ echo "$(DAT) $(DONE): $(TARG)"

##  ------------------------------------------------------------------------  ##
PHONY += clean remove-links remove-files remove-backups

clean: remove-links remove-files ;
	@ echo "$(DAT) $(DONE): $(TARG)"

remove-links:;
	@ $(foreach val, $(DOTFILES), if [ -f "$(BST)/$(val)" ]; then sudo $(RM) "$(BST)/$(val)" 2>&1 >/dev/null ; fi ;)
	@ $(foreach val, $(DOTFILES), if [ -f "/root/$(val)" ]; then sudo $(RM) "/root/$(val)" 2>&1 >/dev/null ; fi ;)
	@ echo "$(DAT) $(DONE): $(TARG)"

remove-files:;
	@ sudo $(RM) -r "${DST}"
	@ $(foreach val, $(ROOTFILES), if [ -f "/root/$(val)" ]; then sudo $(RM) "/root/$(val)" 2>&1 >/dev/null ; fi ;)
	@ echo "$(DAT) $(DONE): $(TARG)"

remove-backups:;
	@ $(foreach val, $(DOTFILES), $(RM) $(addsuffix ~,$(BST)/$(val)) ;)
	@ $(foreach val, $(DOTFILES), sudo $(RM) $(addsuffix ~,/root/$(val)) ;)
	@ echo "$(DAT) $(DONE): $(TARG)"

##  ------------------------------------------------------------------------  ##

_all: banner clean setup deploy post-install-msg ;
	@ echo "$(DAT) $(DONE): $(TARG)"

##  ------------------------------------------------------------------------  ##
PHONY += _dev

_dev: banner clean setup deploy post-install-msg ;
	@ echo "$(DAT) $(DONE): $(TARG)"

##  ------------------------------------------------------------------------  ##
##  Lists all targets defined in this makefile
##  ------------------------------------------------------------------------  ##
PHONY += list

list:;
	@$(MAKE) -pRrn : -f $(MAKEFILE_LIST) 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | sort

##  ------------------------------------------------------------------------  ##
##  Declare the contents of the .PHONY variable as phony. We keep that
##  information in a variable so we can use it in if_changed and friends.
.PHONY: $(PHONY)

##  ------------------------------------------------------------------------  ##

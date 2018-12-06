##  ┌────────────────────────────────────────────────────────────┐
##  │  ____    _    ____  _   _     _____ ___ _     _____ ____   │
##  │ | __ )  / \  / ___|| | | |   |  ___|_ _| |   | ____/ ___|  │
##  │ |  _ \ / _ \ \___ \| |_| |   | |_   | || |   |  _| \___ \  │
##  │ | |_) / ___ \ ___) |  _  |   |  _|  | || |___| |___ ___) | │
##  │ |____/_/   \_\____/|_| |_|   |_|   |___|_____|_____|____/  │
##  │                                                            │
##  └────────────────────────────────────────────────────────────┘
##  ------------------------------------------------------------------------  ##

.SILENT:
.EXPORT_ALL_VARIABLES:
.IGNORE:
.ONESHELL:

SHELL = /bin/sh

##  ------------------------------------------------------------------------  ##

APP_NAME := bash-files
APP_PREF := bash_files
APP_SLOG := "BASH - FILES"
APP_LOGO := ./assets/BANNER
APP_REPO := $(shell git ls-remote --get-url)

DT = $(shell date +'%F %T %Z')
WD := $(shell pwd -P)
BD := $(WD)/bin

DAT = [$(BWhite)$(DT)$(NC)]
SRC := $(WD)/src
DST := /usr/etc/.$(APP_PREF)
BST := $(realpath $(HOME))

$(shell [ -d $(DST) ] || sudo mkdir -p "$(DST)" && sudo chown -R ${LOGNAME}:${LOGNAME} "$(DST)" && sudo chmod 775 "$(DST)");

##  ------------------------------------------------------------------------  ##
include $(BD)/Colors
##  ------------------------------------------------------------------------  ##

LN := ln -sf --backup=simple
CP := cp -prf --backup=simple
MV := mv -f

# CP := cp -prfu --backup=simple
# --backup=numbered

DONE = $(Yellow)DONE$(NC)
TARG = [$(BYellow)$(On_Blue) $@ $(NC)]

##  ------------------------------------------------------------------------  ##
DOTFILES := $(notdir $(wildcard $(SRC)/.??*))
ROOTFILES := $(notdir $(wildcard $(SRC)/root/.??*))
##  ------------------------------------------------------------------------  ##

$(info $(DAT) $(Cyan)USR$(NC):   [$(Orange)$(USER)$(NC)]);
$(info $(DAT) $(Cyan)SRC$(NC):   [$(Purple)$(SRC)$(NC)]);
$(info $(DAT) $(Cyan)DST$(NC):   [$(Purple)$(DST)$(NC)]);
$(info $(DAT) $(Cyan)BST$(NC):   [$(Purple)$(BST)$(NC)]);
$(info $(DAT) $(Cyan)FILES$(NC): [$(Orange)$(DOTFILES)$(NC)]);
$(info $(DAT) $(Cyan)ROOTS$(NC): [$(Orange)$(ROOTFILES)$(NC)]);

##  ------------------------------------------------------------------------  ##
.PHONY: default all

default: all ;
##  ------------------------------------------------------------------------  ##

# Query the default goal
$(info $(DAT) $(BCyan)Default goal$(NC): [$(Purple)$(.DEFAULT_GOAL)$(NC)]);

##  ------------------------------------------------------------------------  ##
##                                  INCLUDES                                  ##
##  ------------------------------------------------------------------------  ##

include $(BD)/*.mk

##  ------------------------------------------------------------------------  ##

.PHONY: setup

setup:;
	@ $(shell [ -d "$(DST)" ] || sudo mkdir -p "$(DST)" && sudo chown -R "$(USER)":"$(USER)" "$(DST)" && sudo chmod 775 "$(DST)")
	@ echo "$(DAT) $(DONE): $(TARG)" ;

##  ------------------------------------------------------------------------  ##

.PHONY: deploy deploy-msg deploy-dot-files deploy-links deploy-root-files

deploy-msg:;
	@ echo "$(DAT) Installation $(BYellow)$(On_Green)FINISHED$(NC)" ;
	@ echo "$(DAT) Please ${BYellow}${On_Red}relogin${NC} to have ${Orange}new settings${NC} effective${NC}" ;

deploy-dot-files:;
	@ $(foreach val, $(DOTFILES), $(CP) "$(SRC)/$(val)" "$(DST)/" ;)
	@ echo "$(DAT) $(DONE): $(TARG)" ;

deploy-links:;
	@ $(foreach val, $(DOTFILES), $(LN) "$(DST)/$(val)" "$(BST)/" ;)
	@ $(foreach val, $(DOTFILES), sudo $(LN) "$(DST)/$(val)" "/root/" ;)
	@ echo "$(DAT) $(DONE): $(TARG)" ;

deploy-root-files:;
	@ $(foreach val, $(ROOTFILES), sudo $(CP) "$(SRC)/root/$(val)" "/root/" ;)
	@ echo "$(DAT) $(DONE): $(TARG)" ;

deploy: deploy-dot-files deploy-links deploy-root-files ;
	@ echo "$(DAT) $(DONE): $(TARG)" ;

##  ------------------------------------------------------------------------  ##

.PHONY: clean remove-links remove-files

clean: remove-links remove-files ;
	@ echo "$(DAT) $(DONE): $(TARG)" ;

remove-files:;
	@ sudo $(RM) -r "${DST}" ;
	@ $(foreach val, $(ROOTFILES), if [ -f "/root/$(val)" ]; then sudo $(RM) "/root/$(val)" 2>&1 >/dev/null ; fi ;)
	@ echo "$(DAT) $(DONE): $(TARG)" ;

remove-links:;
	@ $(foreach val, $(DOTFILES), if [ -f "$(BST)/$(val)" ]; then $(RM) "$(BST)/$(val)" 2>&1 >/dev/null ; fi ;)
	@ $(foreach val, $(DOTFILES), if [ -f "/root/$(val)" ]; then sudo $(RM) "/root/$(val)" 2>&1 >/dev/null ; fi ;)
	@ echo "$(DAT) $(DONE): $(TARG)" ;

remove-backups:;
	@ $(foreach val, $(DOTFILES), $(RM) $(addsuffix ~,$(BST)/$(val)) ;)
	@ $(foreach val, $(DOTFILES), sudo $(RM) $(addsuffix ~,/root/$(val)) ;)
	@ echo "$(DAT) $(DONE): $(TARG)" ;

##  ------------------------------------------------------------------------  ##

all: banner clean setup deploy deploy-msg ;

##  ------------------------------------------------------------------------  ##

.PHONY: dev

dev: banner clean setup deploy deploy-msg ;

##  ------------------------------------------------------------------------  ##
##  Lists all targets defined in this makefile.

.PHONY: list

list:;
	@$(MAKE) -pRrn : -f $(MAKEFILE_LIST) 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | sort

##  ------------------------------------------------------------------------  ##

.PHONY: banner

banner:;
	@ if [ -f "${APP_LOGO}" ]; then cat "${APP_LOGO}"; fi

##  ------------------------------------------------------------------------  ##

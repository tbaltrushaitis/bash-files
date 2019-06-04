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
THIS_FILE := $(lastword $(MAKEFILE_LIST))
TO_NULL = 2>&1 >/dev/null

# $(info [THIS_FILE:$(Blue)$(THIS_FILE)$(NC)])

##  ------------------------------------------------------------------------  ##

APP_NAME := bash-files
APP_PREF := bash_files
APP_SLOG := "BASH FILES"
APP_LOGO := ./assets/BANNER
APP_REPO := $(shell git ls-remote --get-url)

DT = $(shell date +'%T')
WD := $(shell pwd -P)
BD := $(WD)/bin

DAT = [$(White)$(DT)$(NC)]
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
FINE = $(BYellow)$(On_Green)FINISHED$(NC)
TARG = [$(BYellow)$(On_Blue) $@ $(NC)]
THIS = [$(Red)$(THIS_FILE)$(NC)]

##  ------------------------------------------------------------------------  ##
DOTFILES := $(notdir $(wildcard $(SRC)/.??*))
ROOTFILES := $(notdir $(wildcard $(SRC)/root/.??*))
##  ------------------------------------------------------------------------  ##

$(info $(DAT) $(Orange)RUN$(NC):  $(THIS));
$(info $(DAT) $(Orange)USR$(NC):  [$(Yellow)$(USER)$(NC)]);
$(info $(DAT) $(Orange)SRC$(NC):  [$(Cyan)$(SRC)$(NC)]);
$(info $(DAT) $(Orange)DST$(NC):  [$(Purple)$(DST)$(NC)]);
$(info $(DAT) $(Orange)BST$(NC):  [$(Purple)$(BST)$(NC)]);
$(info $(DAT) $(Cyan)FILES$(NC));
$(info $(DAT)   \-- $(Yellow)USER$(NC): [$(White)$(DOTFILES)$(NC)]);
$(info $(DAT)   \-- $(Yellow)ROOT$(NC): [$(White)$(ROOTFILES)$(NC)]);

##  ------------------------------------------------------------------------  ##
.PHONY: default all

default: all ;
	@ echo "$(DAT) $(DONE): $(TARG)" ;

##  ------------------------------------------------------------------------  ##
##  Query default goal.
##  ------------------------------------------------------------------------  ##
ifeq ($(.DEFAULT_GOAL),)
.DEFAULT_GOAL := default
endif
$(info $(DAT) $(Cyan)GOALS$(NC));
$(info $(DAT)   \-- $(Yellow)DEFAULT$(NC): [$(White)$(.DEFAULT_GOAL)$(NC)]);
$(info $(DAT)   \-- $(Yellow)CURRENT$(NC): [$(Purple)$(MAKECMDGOALS)$(NC)]);


##  ------------------------------------------------------------------------  ##
##                                  INCLUDES                                  ##
##  ------------------------------------------------------------------------  ##

include $(BD)/*.mk

##  ------------------------------------------------------------------------  ##

.PHONY: setup

setup:;
	@ $(shell [ -d "$(DST)" ] || sudo mkdir -p "$(DST)" && sudo chown -R "$(USER)":$(id -gn ${USER}) "$(DST)" && sudo chmod 775 "$(DST)")
	@ echo "$(DAT) $(DONE): $(TARG)" ;

##  ------------------------------------------------------------------------  ##

.PHONY: deploy deploy-msg deploy-dot-files deploy-links deploy-root-files

deploy-msg:;
	@ echo "$(DAT) Installation $(FINE)" ;
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
	@ echo "$(DAT) $(DONE): $(TARG)" ;

##  ------------------------------------------------------------------------  ##

.PHONY: dev

dev: banner clean setup deploy deploy-msg ;
	@ echo "$(DAT) $(DONE): $(TARG)" ;

##  ------------------------------------------------------------------------  ##
##  Lists all targets defined in this makefile.

.PHONY: list

list:;
	@$(MAKE) -pRrn : -f $(MAKEFILE_LIST) 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | sort

##  ------------------------------------------------------------------------  ##

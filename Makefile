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
$(shell set -x)

# Since we rely on paths relative to the makefile location,
# abort if make isn't being run from there.
$(if $(findstring /,$(MAKEFILE_LIST)),$(error Please only invoke this makefile from the directory it resides in))
THIS_FILE := $(lastword $(MAKEFILE_LIST))
TO_NULL = 2>&1 >/dev/null
EH = echo -e

##  ------------------------------------------------------------------------  ##
##  Suppress display of executed commands
##  ------------------------------------------------------------------------  ##
$(VERBOSE).SILENT:

##  ========================================================================  ##
##  Set environment variables for the build
##  ========================================================================  ##
.EXPORT_ALL_VARIABLES:
.IGNORE:

##  ------------------------------------------------------------------------  ##
##  Use one shell to run all commands in a given target rather than using
##  the default setting of running each command in a separate shell
##  ------------------------------------------------------------------------  ##
.ONESHELL:

##  ========================================================================  ##
##  Environment variables for the build
##  ========================================================================  ##
include .env

# The shell in which to execute make rules
SHELL := /bin/sh

# Escaping for special characters
EQUALS = =

# $(info [THIS_FILE:$(Blue)$(THIS_FILE)$(NC)])
# $(shell echo "${BASH_SOURCE[0]}")

##  ------------------------------------------------------------------------  ##
# APP_ENV := $(NODE_ENV)
APP_NAME := bash-files
APP_PREF := bf_
APP_SLUG := bash_files
APP_SLOG := "BASH - FILES"
APP_LOGO := ./assets/BANNER

APP_REPO := $(shell git ls-remote --get-url)
APP_HOST := $(shell hostname -s  | tr [:lower:] [:upper:] )

$(shell [ -f .VERSION ] || echo "0.0.0" > .VERSION)
$(shell [ -f .env ] || echo "APP_ENV=production" >> .env)

CODE_VERSION := $(strip $(shell cat .VERSION))
GIT_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
GIT_COMMIT := $(shell git rev-list --remove-empty --max-count=1 --reverse --remotes --date-order)

DT = $(shell date +'%T')
TS = $(shell date +'%s')
WD := $(shell pwd -P)
BD := $(WD)/bin

DAT = [$(Gray)$(DT)$(NC)]
SRC := $(WD)/src
DST := /usr/etc/.$(APP_SLUG)
BST := $(realpath $(HOME))

$(shell [ -d $(DST) ] || sudo mkdir -p "$(DST)" && sudo chown -R ${USER}:$(id -gn ${USER}) "$(DST)" && sudo chmod 775 "$(DST)");

# BUILD_FILE = BUILD-$(CODE_VERSION)
BUILD_FILE = .BUILD
BUILD_CNTR = $(strip $(shell [ -f "$(BUILD_FILE)" ] && cat $(BUILD_FILE) || echo 0))
BUILD_CNTR := $(shell echo $$(( 1 + $(BUILD_CNTR) )))


##  ------------------------------------------------------------------------  ##
##  Colors definition
##  ------------------------------------------------------------------------  ##
include $(BD)/Colors
##  ------------------------------------------------------------------------  ##


##  ------------------------------------------------------------------------  ##
##  BUILDs counter
##  ------------------------------------------------------------------------  ##
$(file > $(BUILD_FILE),$(BUILD_CNTR))
$(info $(DAT) Created file [$(Yellow)$(BUILD_FILE)$(NC):$(Red)$(BUILD_CNTR)$(NC)])
##  ------------------------------------------------------------------------  ##


##  ------------------------------------------------------------------------  ##
APP_ENV := $(shell grep NODE_ENV .env | cut -d "=" -f 2)
ifeq ($(APP_ENV),)
$(info $(DAT) $(Orange)APP_ENV$(NC) is $(Yellow)$(On_Red)NOT DETECTED$(NC)!)
endif
##  ------------------------------------------------------------------------  ##

LN := ln -sf --backup=simple
CP := cp -prf --backup=simple
MV := mv -f
# --backup=numbered

BEGIN = $(Yellow)$(On_Blue)BEGIN$(NC)
DONE = $(Yellow)DONE$(NC)
FINE = $(Yellow)$(On_Green)FINISHED$(NC)
TARG = [$(Yellow)$(On_Blue) $@ $(NC)]
THIS = [$(Red)$(THIS_FILE)$(NC)]

##  ------------------------------------------------------------------------  ##
DOTFILES := $(notdir $(wildcard $(SRC)/.??*))
ROOTFILES := $(notdir $(wildcard $(SRC)/root/.??*))
##  ------------------------------------------------------------------------  ##

$(info $(DAT) $(Orange)APP_ENV$(NC):  [$(Red)$(APP_ENV)$(NC)]);
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
	@ sudo cp /etc/banner /etc/banner.${TS}
	# @ sudo chmod 664 /etc/banner
	# @ sudo $(RM) -vf /etc/banner
	@ sudo figlet-toilet --termwidth --font big --filter border "$(APP_HOST)" --export "utf8" >/etc/banner 2>/dev/null
	@ echo "$(DAT) $(DONE): $(TARG)"


##  ------------------------------------------------------------------------  ##
PHONY += setup

# @ $(shell [ -d "$(DST)" ] || sudo mkdir -p "$(DST)" && sudo chown -R "$(USER)":$(id -gn ${USER}) "$(DST)" && sudo chmod 775 "$(DST)")
# setup: setup-deps create-host-banner ;
setup: setup-deps ;
	@ [ -d "$(DST)" ] || sudo mkdir -p "$(DST)" && sudo chown -R "$(USER)":$(id -gn ${USER}) "$(DST)" && sudo chmod 775 "$(DST)"
	@ echo "$(DAT) $(DONE): $(TARG)"


##  ------------------------------------------------------------------------  ##
PHONY += post-install-msg

post-install-msg:;
	@ echo "$(DAT) Installation $(FINE)"
	@ echo ""
	@ echo "###################################################################"
	@ echo "#                                                                 #"
	@ echo "#                                                                 #"
	@ echo "#                   ${White}C   A   U   T   I   O   N${NC}                     #"
	@ echo "#                                                                 #"
	@ echo "#          This is start #${BPurple}${BUILD_CNTR}${NC} of ${BYellow}${On_Red}BASH-FILES${NC} installer.             #"
	@ echo "#     You MUST ${BWhite}${On_Blue}restart shell${NC} to have ${Orange}new settings${NC} effective.      #"
	@ echo "#                                                                 #"
	@ echo "#                                                                 #"
	@ echo "###################################################################"
	@ echo "$(DAT) $(DONE): $(TARG)"

##  ------------------------------------------------------------------------  ##
PHONY += deploy deploy-assets deploy-dot-files deploy-links deploy-root-files

deploy-assets:;
	@ $(CP) "$(WD)/assets" "$(DST)/"
	@ echo "$(DAT) $(DONE): $(TARG)"

deploy-dot-files:;
	@ $(foreach val, $(DOTFILES), $(CP) "$(SRC)/$(val)" "$(DST)/" ;)
	@ echo "$(DAT) $(DONE): $(TARG)"

deploy-links:;
	@ $(foreach val, $(DOTFILES), $(LN) "$(DST)/$(val)" "$(BST)/" ;)
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

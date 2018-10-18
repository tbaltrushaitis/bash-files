##  ┌──────────────────────────────────────────────────────────────┐
##  │  ____    _    ____  _   _       _____ ___ _     _____ ____   │
##  │ | __ )  / \  / ___|| | | |     |  ___|_ _| |   | ____/ ___|  │
##  │ |  _ \ / _ \ \___ \| |_| |_____| |_   | || |   |  _| \___ \  │
##  │ | |_) / ___ \ ___) |  _  |_____|  _|  | || |___| |___ ___) | │
##  │ |____/_/   \_\____/|_| |_|     |_|   |___|_____|_____|____/  │
##  │                                                              │
##  └──────────────────────────────────────────────────────────────┘
##  ------------------------------------------------------------------------  ##

.SILENT:
.EXPORT_ALL_VARIABLES:
.IGNORE:
.ONESHELL:

SHELL = /bin/sh

##  ------------------------------------------------------------------------  ##

APP_NAME := bash_files
APP_LOGO := ./assets/BANNER
APP_REPO := $(shell git ls-remote --get-url)

DT = $(shell date +'%Y%m%d%H%M%S')

include ./bin/Colors

##  ------------------------------------------------------------------------  ##

.PHONY: default

default: user

##  ------------------------------------------------------------------------  ##
# Lists all targets defined in this makefile.

.PHONY: list
list:
	@$(MAKE) -pRrn : -f $(MAKEFILE_LIST) 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | sort

##  ------------------------------------------------------------------------  ##

.PHONY: banner

banner:
	@ if [ -f "${APP_LOGO}" ]; then cat "${APP_LOGO}"; fi

##  ------------------------------------------------------------------------  ##

.PHONY: clean

clean:
	rm -rf ${APP_NAME} 2>&1 > /dev/null

##  ------------------------------------------------------------------------  ##

.PHONY: deploy-user deploy-root deploy-msg

deploy-user:
	@  cp -vbuf ./src/.bash_profile ~/ \
	&& cp -vbuf ./src/.bash_logout ~/ \
	&& cp -vbuf ./src/.bash_aliases ~/ \
	&& cp -vbuf ./src/.bash_functions ~/ \
	&& cp -vbuf ./src/.bash_colors ~/ \
	&& cp -vbuf ./src/.bash_opts ~/ \
	&& cp -vbuf ./src/.bashrc ~/ \
	&& cp -vbuf ./src/.dircolors ~/ ;

deploy-root: deploy-user;
	@ sudo cp -vbuf ./root/.bash_profile /root/ \
	&& sudo cp -vbuf ./src/.bash_logout /root/ \
	&& sudo ln -s ~/.bash_aliases /root/ \
	&& sudo ln -s ~/.bash_functions /root/ \
	&& sudo ln -s ~/.bash_colors /root/ \
	&& sudo ln -s ~/.bash_opts /root/ \
	&& sudo ln -s ~/.bashrc /root/ \
	&& sudo ln -s ~/.dircolors /root/ ;

deploy-msg:
	@ echo "[${BWhite}$(shell date +'%F %T %Z')${NC}] ${BYellow}Files installed${NC}" \
	&& echo "[${BWhite}$(shell date +'%F %T %Z')${NC}] ${BRed}Please relogin${NC} to have ${BYellow}new settings${NC} effective" ;

##  ------------------------------------------------------------------------  ##
#* means the word "all" doesn't represent a file name in this Makefile;
#* means the Makefile has nothing to do with a file called "all"
#* in the same directory.
.PHONY: user for-user root for-root all for-all

for-user: deploy-user deploy-msg ;
for-root: deploy-root deploy-msg ;
for-all: deploy-user deploy-root deploy-msg ;

user: banner for-user ;
root: banner for-root ;
all: banner for-all ;

##  ------------------------------------------------------------------------  ##

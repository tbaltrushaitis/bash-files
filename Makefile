## ┌──────────────────────────────────────────────────────────────────────────┐
## │ ____           _____ _    _            ______ _____ _      ______  _____ │
## │|  _ \   /\    / ____| |  | |          |  ____|_   _| |    |  ____|/ ____|│
## │| |_) | /  \  | (___ | |__| |  ______  | |__    | | | |    | |__  | (___  │
## │|  _ < / /\ \  \___ \|  __  | |______| |  __|   | | | |    |  __|  \___ \ │
## │| |_) / ____ \ ____) | |  | |          | |     _| |_| |____| |____ ____) |│
## │|____/_/    \_\_____/|_|  |_|          |_|    |_____|______|______|_____/ │
## │                                                                          │
## └──────────────────────────────────────────────────────────────────────────┘
##  ------------------------------------------------------------------------  ##

# .SILENT:
.EXPORT_ALL_VARIABLES:
.IGNORE:
.ONESHELL:

##  ------------------------------------------------------------------------  ##

APP_NAME := bash_files
APP_LOGO := ./assets/BANNER
APP_REPO := $(shell git ls-remote --get-url)

DT = $(shell date +'%Y%m%d%H%M%S')

##  ------------------------------------------------------------------------  ##

.PHONY: default root

default: deploy
root: banner deploy-root deploy-msg

##  ------------------------------------------------------------------------  ##

.PHONY: clone

clone:
	@ git clone ${APP_REPO} ${APP_NAME} \
	&& cd ${APP_NAME} \
	&& git pull ;

##  ------------------------------------------------------------------------  ##

.PHONY: banner

banner:
	@ if [ -f "${APP_LOGO}" ]; then cat "${APP_LOGO}"; fi

##  ------------------------------------------------------------------------  ##

.PHONY: clean

clean:
	rm -rf ${APP_NAME} 2>&1 > /dev/null

##  ------------------------------------------------------------------------  ##

.PHONY: deploy deploy-user deploy-root deploy-msg

deploy: banner deploy-user deploy-msg ;

deploy-user:
	@  cp -vbuf ./src/.bash_profile ~/ \
	&& cp -vbuf ./src/.bashrc ~/ \
	&& cp -vbuf ./src/.bash_aliases ~/ \
	&& cp -vbuf ./src/.bash_functions ~/ \
	&& cp -vbuf ./src/.bash_logout ~/ \
	&& cp -vbuf ./src/.bash_colors ~/ \
	&& cp -vbuf ./src/.dircolors ~/ \
	&& cp -vbuf ./src/.bash_opts ~/ ;

deploy-root: deploy;
	@  sudo cp -vbuf ./root/.bash_profile /root/ \
	&& sudo cp -vbuf ./src/.bash_logout /root/ ;

deploy-msg:
	@ echo "Files installed" \
	&& echo "Please relogin to have new settings effective" ;

##  ------------------------------------------------------------------------  ##
#* means the word "all" doesn't represent a file name in this Makefile;
#* means the Makefile has nothing to do with a file called "all"
#* in the same directory.
.PHONY: all

all: banner deploy-user deploy-root deploy-msg;

##  ------------------------------------------------------------------------  ##

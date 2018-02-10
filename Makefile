##  ------------------------------------------------------------------------  ##

# .SILENT:
.EXPORT_ALL_VARIABLES:
.IGNORE:

##  ------------------------------------------------------------------------  ##

APP_NAME := bash_files
APP_LOGO := ./assets/BANNER

APP_BRANCH := master
APP_REPO := $(shell git ls-remote --get-url)

DT = $(shell date +'%Y%m%d%H%M%S')
NAME = utils/bash_files

##  ------------------------------------------------------------------------  ##

.PHONY: default root

default: deploy
root: banner deploy-root deploy-msg

##  ------------------------------------------------------------------------  ##

.PHONY: clone

clone:
	@ git clone -b ${APP_BRANCH} ${APP_REPO} ${APP_NAME} \
	&& cd ${APP_NAME} \
	&& git pull;

##  ------------------------------------------------------------------------  ##

.PHONY: banner

banner:
	@ if [ -f ./assets/BANNER ]; then cat ./assets/BANNER; fi

##  ------------------------------------------------------------------------  ##

.PHONY: clean

clean:
	rm -rf ${APP_NAME} 2>&1 > /dev/null
	# mv ${APP_NAME} ${APP_NAME}.${DT}

##  ------------------------------------------------------------------------  ##

.PHONY: deploy deploy-user deploy-root deploy-msg

deploy: banner deploy-user deploy-msg

deploy-user:
	@  cp -vbuf .bash_profile ~/   \
	&& cp -vbuf .bashrc ~/         \
	&& cp -vbuf .bash_aliases ~/ 	 \
	&& cp -vbuf .bash_functions ~/ \
	&& cp -vbuf .bash_logout ~/    \
	&& cp -vbuf .bash_colors ~/    \
	&& cp -vbuf .dircolors ~/    	 \
	&& cp -vbuf .bash_opts ~/ 		 ;

deploy-root: deploy;
	@  sudo cp -vbuf ./root/.bash_profile /root/ \
	&& sudo cp -vbuf .bash_logout /root/ 	;

deploy-msg:
	@ echo "Files installed" \
	&& echo "Please relogin to have new settings effective";

##  ------------------------------------------------------------------------  ##
#* means the word "all" doesn't represent a file name in this Makefile;
#* means the Makefile has nothing to do with a file called "all"
#* in the same directory.
.PHONY: all

all: banner deploy-user deploy-root deploy-msg;

##  ------------------------------------------------------------------------  ##

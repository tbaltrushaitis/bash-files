##  ------------------------------------------------------------------------  ##

.SILENT:

.EXPORT_ALL_VARIABLES:

##  ------------------------------------------------------------------------  ##

APP_NAME="bash_files"
APP_REPO="https://github.com/tbaltrushaitis/bash-files.git"
APP_ENV="master"

DT=`$(date +"%Y%m%d%H%M%S")`
NAME = utils/bash_files

##  ------------------------------------------------------------------------  ##

.PHONY: default root

default: banner deploy
root: banner deploy deploy-root

##  ------------------------------------------------------------------------  ##

.PHONY: clone

clone:
	@ git clone -b ${APP_ENV} ${APP_REPO} ${APP_NAME} \
	&& cd ${APP_NAME} \
	&& git pull;

##  ------------------------------------------------------------------------  ##

.PHONY: banner

banner:
OK_BANNER := $(shell [ -e BANNER ] && echo 1 || echo 0)
ifeq ($(OK_BANNER), 1)
	@ cat BANNER
	@ echo -e "\n";
endif

##  ------------------------------------------------------------------------  ##

.PHONY: clean

clean:
	rm -rf ${APP_NAME} 2>&1 > /dev/null
	# mv ${APP_NAME} ${APP_NAME}.${DT}

##  ------------------------------------------------------------------------  ##

.PHONY: deploy deploy-user deploy-root

deploy: deploy-user

deploy-user:
	@  cp .bash_profile ~/   \
	&& cp .bashrc ~/         \
	&& cp .bash_aliases ~/ 	 \
	&& cp .bash_functions ~/ \
	&& cp .bash_logout ~/    \
	&& cp .bash_colors ~/    \
	&& cp .bash_opts ~/ ;

deploy-root:
	cp root/.bash_profile ~/ ;

##  ------------------------------------------------------------------------  ##

all: default root clone clean deploy deploy-user deploy-root

#* means the word "all" doesn't represent a file name in this Makefile;
#* means the Makefile has nothing to do with a file called "all" in the same directory.

.PHONY: all

##  ------------------------------------------------------------------------  ##

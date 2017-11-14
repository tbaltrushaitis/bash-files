##  ------------------------------------------------------------------------  ##

APP_NAME="bash_files"
APP_REPO="https://github.com/tbaltrushaitis/bash-files.git"
APP_ENV="master"

DT=`$(date +"%Y%m%d%H%M%S")`
NAME = utils/bash_files

##  ------------------------------------------------------------------------  ##

default: deploy
root: deploy deploy-root

##  ------------------------------------------------------------------------  ##

clone:
	git clone -b ${APP_ENV} ${APP_REPO} ${APP_NAME} && cd ${APP_NAME} && git pull

clean:
	rm -rf ${APP_NAME} 2>&1 > /dev/null
	# mv ${APP_NAME} ${APP_NAME}.${DT}

##  ------------------------------------------------------------------------  ##

deploy: deploy-user

deploy-user:
	cp .bash_profile ~/      \
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

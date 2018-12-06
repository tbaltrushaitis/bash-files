[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/tbaltrushaitis/bash-files/blob/master/LICENSE)

# Bash Files #

<p align="center">
  <img src="assets/img/bash-logo-web.png" alt="Bash Logo" />
</p>

Stack of useful .bashrc configs for OS Linux shell

`bashrc-configs` `bash-prompt` `bash-hacks` `bashrc` `bash-script` `userscripts` `tips-and-tricks` `configuration` `bash` `bash-scripting` `bash-alias` `bash-profile` `shell-scripts` `colorization` `tips-tricks` `cli-utilities` `linux-shell` `bash-utils` `bash-tool`

---

#### Provides: ####
- [x] Colorful console output
- [x] Easy-to-remember aliases for most of commands with their top-used params
- [x] Up to 70% economy of your keyboard input time
- [x] Collect and gather basic system stats for fast incidents investigations

### How to setup this stack of useful .bashrc configs ###
- Installation is so easy as so koala :koala: can do it

---

## Usage ##

### Download ###
```shell
$ APP_NAME=bash-files \
&& git clone https://github.com/tbaltrushaitis/${APP_NAME}.git \
&& cd ${APP_NAME} ;
```

### Setup for current user and root ###
```shell
$ make
```

<div align="center">
  <img src="assets/img/make.png" alt="Output of make command"/>
</div>

---

## Enjoy! ##

<div align="center">
  <img max-width="675px" max-height="600px" src="assets/img/user-login-and-sudo.png" />
</div>

---

## Aliases Explained ##

<details>
  <summary>visits - Provide list of top ip-addresses extracted from given log file</summary>
  <div align="center">
    <img max-width="795px" max-height="792px" src="assets/img/alias-visits.png" />
  </div>
</details>

<details>
  <summary>zz - Become root</summary>
  <div align="center">
    <img max-width="674px" max-height="300px" src="assets/img/alias-zz.png" />
  </div>
</details>

<details>
  <summary>qq - Logout from current session</summary>
  <div align="center">
    <img max-height="795px" max-width="312px" src="assets/img/alias-qq-logout.png" />
  </div>
</details>

<details>
  <summary>ii - Show basic hardware and networking information about the host</summary>
  <div align="center">
    <img max-height="683px" max-width="424px" src="assets/img/alias-ii.png" />
  </div>
</details>

---

## Special tools Aliases ##

| + | Input | Execute | Description |
|:-:|:-----:|:--------|:------------|
| - | visits | f(<LOG_FILE>, [COUNT]) | Show top [COUNT] IPs extracted from <LOG_FILE> |
| - | delempty | find . -type f -size 0 -exec rm -v {} \; | Find all empty files and delete them |
| - | scs | screen -ls | Show list of active screens |
| - | scx | screen -x | Attach to the screen which name is provided as parameter |
| - | scr | screen -S "sockname" | Create new screen session with name provided as parameter, e.g. <pid>.sockname |
| - | psnode | ps | Show node.js processes |
| - | zz | sudo -i | Become root |
| - | qq | exit | Exit current session |
| - | iip | f() | Show IP adress on ethernet/wi-fi |
| - | conns | f() | Output list of network connections ESTABLISHED |
| - | stripcomments | sed -e '/^#/d' FILE | Remove comments from FILE |
| - | cr2lf | sed -i 's/\r$//' <FILE> | FIX Windows (CRLF) to Unix (LF) in <FILE> |

## Full Command-line Aliases List ##

| + | Input | Execute | Description |
|:-:|:-----:|:--------|:------------|
| - | .. | cd .. | Go up 1 directory |
| - | c | clear | Clear terminal window |
| - | screenls | screen -ls | Show list of active screens |
| - | k9 | kill -9 | Send -HUP signal to process |
| - | npmr | npm run | -
| - | npms | npm start | -
| - | npmt | npm run test | -
| - | npmb | npm run build | -
| - | alert | notify-send --urgency | -
| - | chgrp | chgrp --preserve-root | -
| - | chmod | chmod --preserve-root | -
| - | chown | chown --preserve-root | -
| - | cp | cp -prb | -
| - | cpuinfo | lscpu | -
| - | curli | curl -I | -
| - | debug | set -o nounset; set -o xtrace | -
| - | df | df -kTH | -
| - | dir | dir --color | -
| - | du | du -kh | -
| - | egrep | egrep --color | -
| - | fastping | ping -c 100 -s.2 | -
| - | fgrep | fgrep --color | -
| - | firewall | iptlist | -
| - | grep | grep --color | -
| - | h | history | Show commands history |
| - | headerc | curl -I --compress | -
| - | httpdreload | sudo /usr/sbin/apachectl -k graceful | -
| - | httpdrestart | sudo /etc/init.d/httpd restart | -
| - | httpdtest | sudo /usr/sbin/apachectl -t && /usr/sbin/apachectl -t -D DUMP_VHOSTS | -
| - | ipt | sudo /sbin/iptables | -
| - | iptlist | sudo /sbin/iptables -L -n -v --line-numbers | -
| - | iptlistfw | sudo /sbin/iptables -L FORWARD -n -v --line-numbers | -
| - | iptlistin | sudo /sbin/iptables -L INPUT -n -v --line-numbers | -
| - | iptlistout | sudo /sbin/iptables -L OUTPUT -n -v --line-numbers | -
| - | j | jobs -l | -
| - | l | ls -CF | -
| - | la | ll -A | -
| - | lc | ls -ltcr | -
| - | libpath | echo -e ${LD_LIBRARY_PATH//:/\\n} | -
| - | lk | ls -lSr | -
| - | ll | ls -lvF | -
| - | ln | ln -i | -
| - | lr | ll -R | -
| - | ls | ls --color | -
| - | lt | ls -ltr | -
| - | lu | ls -ltur | -
| - | lx | ls -lXB | -
| - | meminfo | free -m -l -t | -
| - | mkdir | mkdir -p | -
| - | most | du -shx * \| grep -w "[0-9]*G" | -
| - | mount | mount \| column -t | -
| - | nocomment | grep -Ev '\''^(#|$)'\''' | -
| - | partusage | df -hlT --exclude-type | -
| - | path | echo -e ${PATH//:/\\n} | -
| - | ports | netstat -tulanp | -
| - | pscpu | ps auxf \| sort -nr -k 3 | -
| - | pscpu10 | ps auxf \| sort -nr -k 3 \| head -10 | -
| - | psmem | ps auxf \| sort -nr -k 4 | -
| - | psmem10 | ps auxf \| sort -nr -k 4 \| head -10 | -
| - | rights | sudo find . -type f -exec chmod 664 {} \; && sudo find . -type d -exec chmod 775 {} \; && sudo find . -type f -name "*.sh" -exec sudo chmod a+x {} \; | -
| - | rm | rm -i --preserve-root | -
| - | sha1 | openssl sha1 | -
| - | totalusage | df -hl --total \| grep total | -
| - | usage | du -h --max-depth | -
| - | which | type -a | -

---

### Snippet that create structure for table above ###

```shell
# markdown of table above prepared with this snippet:
$ echo "| + | Input | Execute | Description |"
$ echo "|:-:|:-----:|:--------|:------------|"
$ alias | cut -b7- | awk -F"=" '{print "| " $1 " | " $2 " |"}'
```

---

## CHANGELOG ##

See [Changelog file][Changelog] for details

---

> **Note:**  We're ready to get help in creation of tomorrow web ... maybe its you just come there as a new contributor?

---

### :link: More Info ###

 - [GitHub / Basic writing and formatting syntax](https://help.github.com/articles/basic-writing-and-formatting-syntax/)
 - [BitBucket Markdown Howto](https://bitbucket.org/tutorials/markdowndemo)
 - [Creating an Automated Build](https://docs.docker.com/docker-hub/builds/)
 - [Linking containers](https://docs.docker.com/engine/userguide/networking/default_network/dockerlinks.md)
 - [Cross-host linking containers](https://docs.docker.com/engine/admin/ambassador_pattern_linking.md)

---

> :calendar: Developed on **20th of November 2016**

:scorpius:

[Changelog]: CHANGELOG.md

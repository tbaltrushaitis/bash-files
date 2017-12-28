# Bash Configuration Files #

<p align="center">
  <img src="assets/img/bash-logo-web.png" alt="Bash Logo">
</p>

`bash` `tips & tricks` `linux`

---

### Stack of useful .bashrc configs ###
## - Make it easy

---

## Usage ##

### Download ###
```bash
$ git clone https://github.com/tbaltrushaitis/bash-files.git && cd bash-files
```

### Setup for current user ###
```bash
$ make
```

### Setup for root ###
```bash
$ make root
```

### Setup for current user and for root ###
```bash
$ make all
```

![Setup View](assets/img/make-all.png)

---

## Enjoy! ##

![Shell Login View](assets/img/user-login-and-sudo.png)

![Predefined Aliases](assets/img/alias-ii.png)

---

## Useful Commands ##

<details>
<summary>qq</summary>

Logout from current session

<div align="center">
  <img max-height="500px" max-width="500px" src="//github.com/tbaltrushaitis/bash-files/blob/master/assets/img/alias-qq-logout.png" />
</div>
</details>

<details>
<summary>ii</summary>

Show basic hardware and networking information about the host

<div align="center">
  <img max-height="500px" max-width="500px" src="//github.com/tbaltrushaitis/bash-files/blob/master/assets/img/alias-ii.png" />
</div>
</details>

---

## Full Command-line Aliases List ##

```bash
$ echo "| + | Input | Execute | Description |"
$ echo "|:-:|:-----:|:--------|:------------|"
$ alias | cut -b7- | awk -F"=" '{print "| " $1 " | " $2 " |"}'
```

| + | Input | Execute | Description |
|:-:|:-----:|:--------|:------------|
| - | alert | notify-send --urgency | -
| - | .. | cd .. | -
| - | c | clear | -
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
| - | h | history | -
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
| - | k9 | kill -9 | -
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
| - | npmr | npm run | -
| - | npms | npm start | -
| - | npmt | npm run test | -
| - | partusage | df -hlT --exclude-type | -
| - | path | echo -e ${PATH//:/\\n} | -
| - | ports | netstat -tulanp | -
| - | pscpu | ps auxf \| sort -nr -k 3 | -
| - | pscpu10 | ps auxf \| sort -nr -k 3 \| head -10 | -
| - | psmem | ps auxf \| sort -nr -k 4 | -
| - | psmem10 | ps auxf \| sort -nr -k 4 \| head -10 | -
| - | psnode | ps ax \| grep node | -
| - | qq | exit | -
| - | rights | sudo find . -type f -exec chmod 664 {} \; && sudo find . -type d -exec chmod 775 {} \; && sudo find . -type f -name "*.sh" -exec sudo chmod a+x {} \; | -
| - | rm | rm -i --preserve-root | -
| - | screenls | screen -ls | -
| - | scs | screen -ls | -
| - | scx | screen -x | -
| - | sha1 | openssl sha1 | -
| - | totalusage | df -hl --total \| grep total | -
| - | usage | du -h --max-depth | -
| - | which | type -a | -
| - | zz | sudo -i | -

---

<p align="center">
  <h2 align="center">Easy Shell :: Changelog</h2>
</p>

<p align="center">
  <a href="#">
    <img src="assets/img/bash-logo-web.png" height="158px" width="376px" max-height="158px" max-width="376px" alt="Bash Logo" />
  </a>
</p>

---

# :memo: Changelog #

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

<!-- --- -->

<!-- ## [Unreleased] - Current ## -->
<!-- ### Added ### -->
<!-- ### Changed ### -->
<!-- ### Fixed ### -->
<!-- ### Removed ### -->

---

## [2021-08-05] ##
### Fixed ###
- :feet: Error in **Makefile**: `cannot create /etc/banner: Permission denied` :x:

---

## [2021-07-23] ##
### Changed ###
- Improved load script notifications
- Improved `greeting` message

### Fixed ###
- Various small fixes and improvements

---

## [2021-03-16] ##
### Added ###
- Create file `/etc/banner` with `$(hostname -s)` as context using [figlet](http://www.figlet.org/)

---

## [2020-09-14] ##
### Added ###
- Alias count="find . -type f | wc -l"

---

## [2020-08-27] ##
### Changed ###
- Function for alias `psnode='psnode'`

---

## [2020-08-07] ##
### Added ###
- Screenshot for  `h='history'`

---

## [2020-05-27] ##
### Added ###
- alias `npmi='npm install'`

---

## [2020-02-23] ##
### Added ###
- `Gray` color for console output
- `PHONY` variable
- Support for [Predictable Network Interface Names](https://systemd.io/PREDICTABLE_INTERFACE_NAMES/)

### Changed ###
- Few improvements in console output
- Few screen-shots

### Fixed ###
- [IP-address extract command in `visits()`

### Removed ###
- `src/labs` directory

---

## [2019-11-12] ##
### Changed ###
- Just a few small improvements
- Improved disk usage printing for `ii()` function

---

## [2019-08-10] ##
### Added ###
- `pwg` command description in help topic `bfh`

---

## [2019-07-25] ##
### Added ###
- Bash alias `mkd` - Create a new directory and enter it

---

## [2019-06-03] ##
### Added ###
- Bash alias `pwg` - shorthand for `pwgen -s1 32`
- Special commands help topic `bfh` - shorthand for `bfiles_help`

### Changed ###
- Root greeting message

---

## [2019-05-19] ##
### Added ###
- Bash alias `npmo` - shorthand for `npm outdated`

### Changed ###
- Few log output format improvements

---

## [2019-04-09] ##
### Added ###
- Alias `med <FILE>` - open file in Midnight Commander's editor

### Changed ###
- Simplified apache restart command parameters
- Simplified `iptables` aliases
- Simplified `ls` aliases

### Fixed ###
- Few comments and indentation improvements

---

## [2018-12-06] ##
### Added ###
- This `CHANGELOG.md` file
- Optional **COUNT** argument as a second parameter to `visits` function to control number of IP addresses appear in command's output

### Changed ###
- Some code reorganization that do not affect overall functionality

### Fixed ###
- Double notify about export of `.bash_functions` instead of `.bashrc`
- `stripcomments` and `nocomment` functions and their description

---

## [2016-11-20] ##
- [x] Initial release

---

:scorpion:

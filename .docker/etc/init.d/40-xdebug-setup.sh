#!/bin/bash

set -eu
export TERM=xterm

# Bash Colors
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
blue=`tput setaf 4`
magenta=`tput setaf 5`
cyan=`tput setaf 6`
white=`tput setaf 7`
bold=`tput bold`
reset=`tput sgr0`
separator=$(echo && printf '=%.0s' {1..100} && echo)

# Logging Functions
log() {
    color=$white

    [[ "$2" ]] && color=$2
    [[ "$1" ]] && echo "${bold}${color}[LOG `date +'%T'`]${reset} $1";
}

echo $separator;
log "Preparing Xdebug configuration..." $magenta

if [[ -z $XDEBUG_ENABLE || -z $XDEBUG_IDEKEY ]]; then
  log "One or more variables are undefined. Skipping..." $red
else
    echo "xdebug.remote_enable=$XDEBUG_ENABLE" >> /etc/php5/mods-available/xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /etc/php5/mods-available/xdebug.ini \
    && echo "xdebug.remote_connect_back=on" >> /etc/php5/mods-available/xdebug.ini \
    && echo "xdebug.remote_port=9000" >> /etc/php5/mods-available/xdebug.ini \
    && echo "xdebug.max_nesting_level=1000" >> /etc/php5/mods-available/xdebug.ini \
    && echo "xdebug.idekey=$XDEBUG_IDEKEY" >> /etc/php5/mods-available/xdebug.ini

    log "Set Xdebug with remote_enable $XDEBUG_ENABLE and idekey: $XDEBUG_IDEKEY" $yellow
fi

log "All done. Good to go!" $green
echo $separator;

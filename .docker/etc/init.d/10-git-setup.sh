#!/bin/sh

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
log "Preparing Git configuration..." $magenta

if [[ -z $GIT_CONFIG_NAME || -z $GIT_CONFIG_EMAIL ]]; then
  log "One or more variables are undefined. Skipping..." $red
else
    /usr/bin/git config --global core.editor "vim"
    /usr/bin/git config --global user.name "$GIT_CONFIG_NAME"
    /usr/bin/git config --global user.email "$GIT_CONFIG_EMAIL"
    log "Set gitconfig with global user name $GIT_CONFIG_NAME and email $GIT_CONFIG_EMAIL" $yellow
fi

log "All done. Good to go!" $green
echo $separator;

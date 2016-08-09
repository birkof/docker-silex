#!/bin/bash

set -eu
export TERM=xterm

BLACKFIRE_CONFIG_FILE="/etc/php5/mods-available/blackfire.ini"
BLACKFIRE_LOG_FILE="/var/log/php5/blackfire.log"

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
log "Preparing Blackfire configuration..." $magenta

if [ -z "${BLACKFIRE_PORT:-}" ]; then
  log "One or more variables are undefined. Skipping..." $red
else
	sed -i "s@^blackfire.agent_socket = .*@blackfire.agent_socket = $BLACKFIRE_PORT@" $BLACKFIRE_CONFIG_FILE
	sed -i "s@^;blackfire.log_level = .*@blackfire.log_level = $BLACKFIRE_ENV_BLACKFIRE_LOG_LEVEL@" $BLACKFIRE_CONFIG_FILE
	sed -i "s@^;blackfire.server_id.*@blackfire.server_id = $BLACKFIRE_ENV_BLACKFIRE_SERVER_ID@" $BLACKFIRE_CONFIG_FILE
	sed -i "s@^;blackfire.server_token.*@blackfire.server_token = $BLACKFIRE_ENV_BLACKFIRE_SERVER_TOKEN@" $BLACKFIRE_CONFIG_FILE
	sed -i "s@^;blackfire.log_file = .*@blackfire.log_file = $BLACKFIRE_LOG_FILE@" $BLACKFIRE_CONFIG_FILE

	log "Successfully configuration with the following properties:" $cyan
	log "blackfire.agent_socket = $BLACKFIRE_PORT" $yellow
	log "blackfire.log_level = $BLACKFIRE_ENV_BLACKFIRE_LOG_LEVEL" $yellow
	log "blackfire.server_id = $BLACKFIRE_ENV_BLACKFIRE_SERVER_ID" $yellow
	log "blackfire.server_token = $BLACKFIRE_ENV_BLACKFIRE_SERVER_TOKEN" $yellow
	log "blackfire.log_file = $BLACKFIRE_LOG_FILE" $yellow
fi

log "All done. Good to go!" $green
echo $separator;

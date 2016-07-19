#!/bin/sh

set -eu
export TERM=xterm

NGINX_ROOT_DIR="/var/www"
NGINX_SITES_AVAILABLE="/etc/nginx/sites-available"
NGINX_SITES_ENABLED="/etc/nginx/sites-enabled"

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

# Enable available nginx vhosts
echo $separator;
log "Preparing Nginx server configuration..." $magenta

if [ "$(ls $NGINX_SITES_AVAILABLE/*.conf)" ]; then
    for vhost in $NGINX_SITES_AVAILABLE/*.conf; do
        file=$(basename "$vhost")
        filename=$(echo $file | cut -f 1 -d '.')

    if [ -f "$NGINX_SITES_ENABLED/$file" ]; then
        log "Site ($file) appears to be already enabled. Skipping..." $red
        continue
    fi

    mkdir -p $NGINX_SITES_AVAILABLE $NGINX_SITES_ENABLED "$NGINX_ROOT_DIR/$filename" \
        && chown -R www-data:www-data $NGINX_ROOT_DIR \
        && chmod -R g+w $NGINX_ROOT_DIR \
        && chmod -R +s $NGINX_ROOT_DIR

    sed -i "s/APP_NAME/$filename/g" $NGINX_SITES_AVAILABLE/$file
    ln -sf "$NGINX_SITES_AVAILABLE/$file" -T "$NGINX_SITES_ENABLED/$file"
    log "Enable vhost & create project files directory in $NGINX_ROOT_DIR/$filename" $yellow
    done
fi

log "All done. Good to go!" $green
echo $separator;

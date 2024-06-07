#!/bin/bash

# Define color codes
# shellcheck disable=SC2034
COLOR_ERROR='\033[0;31m'
COLOR_SUCCESS='\033[0;32m'
COLOR_WARNING='\033[0;33m'
COLOR_INFO='\033[0m' # No Color


DELIMITER="------------------------------------------------------------------------------------"
AUTOCONFIG_START="# AUTOCONFIG
# ------------------------------------------------------------------------------------------------------------"
AUTOCONFIG_END="# ------------------------------------------------------------------------------------------------------------
# END AUTOCONFIG"

rprint() {
    local color="$1"
    shift
    local no_newline=false
    if [[ "$1" == "-n" ]]; then
        no_newline=true
        shift
    fi
    local text="$*"
    if $no_newline; then
        printf "%b%b%b" "$color" "$text" "\033[0m"
    else
        printf "%b%b%b\n" "$color" "$text" "\033[0m"
    fi
}
export -f rprint



err()(set -o pipefail;"$@" 2> >(sed $'s,.*,\e[31m&\e[m,'>&2))
export -f err


alias INFO='rprint $COLOR_INFO'
alias PASS='rprint $COLOR_SUCCESS'
alias FAIL='rprint $COLOR_ERROR'
alias WARN='rprint $COLOR_WARNING'




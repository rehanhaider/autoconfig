#!/bin/bash

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
#export -f rprint



err()(set -o pipefail;"$@" 2> >(sed $'s,.*,\e[31m&\e[m,'>&2))
#export -f err

print_delimiter() {
    echo -e "\n"
    rprint "${COLOR_WARN}" -n "Step $((++STEP)): "
    rprint "${COLOR_WARN}" "${1}"
    rprint "${COLOR_WARN}" "${DELIMITER}"
}

alias INFO='rprint "${COLOR_INFO}" -n "[INFO]: " && rprint "${COLOR_INFO}"'
alias PASS='rprint "${COLOR_PASS}" -n "[PASS]: " && rprint "${COLOR_PASS}"'
alias FAIL='rprint "${COLOR_FAIL}" -n "[FAIL]: " && rprint "${COLOR_FAIL}"'
alias WARN='rprint "${COLOR_WARN}" -n "[WARN]: " && rprint "${COLOR_WARN}"'
alias NEWLINE='rprint "${COLOR_INFO}" -n "\n"'


prompt_and_execute() {
    local message=$1
    local func=$2

    if [ "$SILENT_MODE" = false ]; then
        # shellcheck disable=SC1091
        read -r -p "Proceed with $message [Y/N]  " yn
        case $yn in
            [Yy]* ) ($func);;
            [Nn]* ) 
                    echo -n "Skipping $message... "
                    # shellcheck disable=SC2034
                    for i in {1..8}; do echo -n "." && sleep 0.25; done;;
            * ) echo "Please answer Y or N.";;
        esac
    else
        ($func)
    fi
}
#!/bin/bash
shopt -s expand_aliases

# Set default values
SILENT_MODE=true
# shellcheck disable=SC2034
MAX_BACKUPS=10 
CUR_DIR=$(pwd)
AUTOCONFIG_DIR="${HOME}/.autoconfig"
# shellcheck disable=SC2034
AUTOCONFIG_BACKUPS_DIR="${AUTOCONFIG_DIR}/.backups"
SCRIPT_DIR="${CUR_DIR}/wsl/scripts"
STATIC_DIR="${CUR_DIR}/wsl/static"
# shellcheck disable=SC2034
THEME_DIR="${CUR_DIR}/themes"

# shellcheck disable=SC2034
STEP=0
# Set silent mode
while getopts ":i" opt; do
	case ${opt} in
		i )
			SILENT_MODE=false
			;;
		* )
			echo "Usage: $0 [-i]"
			echo "Options:"
			echo "  -i  Interactive mode"
			exit 1
			;;
	esac
done

# shellcheck disable=SC1091
source "${STATIC_DIR}/ascii.sh"
# shellcheck disable=SC1091
source "${STATIC_DIR}/format.sh"
# shellcheck disable=SC1091
source "${STATIC_DIR}/intro.sh"


if [ "$SILENT_MODE" = true ]; then
	# Display ASCII Art
	FAIL "\nRunning in silent mode ..."
fi


if [ "$SILENT_MODE" = false ]; then
	# Prompt the user to continue
	while true; do
		echo -e -n "\n"
		read -r -p "Do you wish to continue? [Y/N] " yn
		case $yn in
			[Yy]* ) break;;
			[Nn]* ) exit;;
			* ) echo "Please answer Y or N";;
		esac
	done
fi
WARN "\n${DELIMITER}"
INFO -n "\nWSL Autoconfig in starting "



# Sleep for 5 seconds
# shellcheck disable=SC2034
for i in {1..4}; do
	INFO -n "."
	sleep 0.25
done
WARN "\n\n${DELIMITER}"



# shellcheck disable=SC1091
#source "${SCRIPT_DIR}/install_packages.sh"

# shellcheck disable=SC1091
source "${SCRIPT_DIR}/prepare_wac.sh"

# shellcheck disable=SC1091
source "${SCRIPT_DIR}/bash_config.sh"

# shellcheck disable=SC1091
source "${SCRIPT_DIR}/omp_config.sh"


#!/bin/bash

SILENT_MODE=false
# shellcheck disable=SC2034
STEP=0
# Set silent mode
while getopts ":s" opt; do
	case ${opt} in
		s )
			SILENT_MODE=true
			;;
		* )
			echo "Usage: $0 [-s]"
			echo "Options:"
			echo "  -s  Silent mode"
			exit 1
			;;
	esac
done

# shellcheck disable=SC1091
source ./wsl/static/ascii.sh
# shellcheck disable=SC1091
source ./wsl/static/format.sh
# shellcheck disable=SC1091
source ./wsl/static/intro.sh


if [ "$SILENT_MODE" = true ]; then
	# Display ASCII Art
	echo -e "${RED}\nRunning in silent mode ...${NC}"
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
echo -e "\n${DELIMITER}"
echo -e -n "\nWSL Autoconfig in starting "
# Sleep for 5 seconds
# shellcheck disable=SC2034
for i in {1..10}; do
	echo -n "."
	sleep 0.25
done
echo -e "\n\n${DELIMITER}"

# shellcheck disable=SC1091
source ./wsl/scripts/packages.sh

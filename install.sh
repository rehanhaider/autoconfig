#!/bin/bash

SILENT_MODE=false
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

# ASCII Art
# shellcheck disable=SC1091
source ./static/ascii.sh

# Colours
# shellcheck disable=SC1091
source ./static/colours.sh



if [ "$SILENT_MODE" = true ]; then
	# Display ASCII Art
	echo "Running in silent mode ..."
fi

# Display disclaimer
# shellcheck disable=SC1091
source ./static/disclaimer.sh

if [ "$SILENT_MODE" = false ]; then
	# Prompt the user to continue
	while true; do
		echo -e "\n"
		read -r -p "Do you wish to continue? [Y/N] " yn
		case $yn in
			[Yy]* ) break;;
			[Nn]* ) exit;;
			* ) echo "Please answer Y or N.n";;
		esac
	done
fi

echo -e -n "\nWSL Autoconfig in starting "

# Sleep for 5 seconds
# shellcheck disable=SC2034
for i in {1..12}; do
	echo -n "."
	sleep 0.25
done

echo -e "\n"

# shellcheck disable=SC1091
source ./scripts/update.sh
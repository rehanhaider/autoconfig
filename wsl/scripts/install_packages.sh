#!/bin/bash

# DEFINITIONS
## Update apt packages
update_packages() {
    err sudo apt update -y
    echo -e "\n"
    WARN -n "Step $((++STEP)): "
    WARN "Updating packages..."
    WARN "${DELIMITER}"
    err sudo apt upgrade -y
    INFO "Packages updated successfully."
}

## Install required packages
install_packages() {
    err sudo apt install -y curl nano wget
}

# MAIN

## Prompt the user to update packages
echo -e "\n"
WARN -n "Step $((++STEP)): "
WARN "Updating package lists..."
WARN "${DELIMITER}"


if [ "$SILENT_MODE" = false ]; then
    # shellcheck disable=SC1091
    read -r -p "Proceed with updating apt packages? [Y/N]  " yn
    case $yn in
        [Yy]* ) update_packages;;
        [Nn]* ) 
                echo -n "Skipping updating packages "
                # shellcheck disable=SC2034
                for i in {1..8}; do echo -n "." && sleep 0.25; done;
                echo -e "\n";;
        * ) echo "Please answer Y or N.";;
    esac
else
    update_packages
fi

## Prompt the user to install required packages
echo -e "\n"
WARN -n "Step $((++STEP)): "
WARN "Installing required packaes..."
WARN "${DELIMITER}"


if [ "$SILENT_MODE" = false ]; then
    # shellcheck disable=SC1091
    read -r -p "Proceed with installing required packages? [Y/N]  " yn
    case $yn in
        [Yy]* ) install_packages;;
        [Nn]* ) 
                echo -n "Skipping installing required packages "
                # shellcheck disable=SC2034
                for i in {1..8}; do echo -n "." && sleep 0.25; done;;
        * ) echo "Please answer Y or N.";;
    esac
else
    install_packages
fi
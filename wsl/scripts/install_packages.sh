#!/bin/bash

# Update apt packages
update_packages() {
    echo -e "\n"
    rprint "${WARNING}" -n "Step $((++STEP)): "
    rprint "${WARNING}" "Updating package lists..."
    rprint "${WARNING}" "${DELIMITER}"
    err sudo apt update -y
    echo -e "\n"
    rprint "${WARNING}" -n "Step $((++STEP)): "
    rprint "${WARNING}" "Updating packages..."
    rprint "${WARNING}" "${DELIMITER}"
    err sudo apt upgrade -y
}

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


# Install required packages
install_packages() {
    echo -e "\n"
    rprint "${WARNING}" -n "Step $((++STEP)): "
    rprint "${WARNING}" "Installing required packaes..."
    rprint "${WARNING}" "${DELIMITER}"
    sudo apt install -y curl nano wget
}

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
#!/bin/bash

# Update apt packages
update_packages() {
    echo -e "\n"
    echo -e -n "${BOLD}${YELLOW}Step $((++STEP)): ${NC}"
    echo -e "${BOLD}${YELLOW}Updating package lists ...${NC}"
    echo -e "${DELIMITER}"
    sudo apt update -y
    echo -e "\n"
    echo -e -n "${BOLD}${YELLOW}Step $((++STEP)): ${NC}"
    echo -e "${BOLD}${YELLOW}Updating packages ...${NC}"
    echo -e "${DELIMITER}"
    sudo apt upgrade -y
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
    echo -e -n "${BOLD}${YELLOW}Step $((++STEP)): ${NC}"
    echo -e "${BOLD}${YELLOW}Installing required packages ...${NC}"
    echo -e "${DELIMITER}"
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
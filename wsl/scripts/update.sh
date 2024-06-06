#!/bin/bash

update_packages() {
    echo -e "\n"
    echo -e -n "${BOLD}${YELLOW}Step $((++STEP)): ${NC}"
    echo -e "${BOLD}${YELLOW}Updating package lists ...${NC}"
    echo -e "${BOLD}${YELLOW}${DELIMITER}${NC}"
    sudo apt update -y
    echo -e "\n"
    echo -e -n "${BOLD}${YELLOW}Step $((++STEP)): ${NC}"
    echo -e "${BOLD}${YELLOW}Updating packages ...${NC}"
    echo -e "${BOLD}${YELLOW}${DELIMITER}${NC}"
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
                for i in {1..12}; do echo -n "." && sleep 0.25; done;;
        * ) echo "Please answer Y or N.";;
    esac
else
    update_packages
fi
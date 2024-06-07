#!/bin/bash

backup() {
    echo -e "\n"
    echo -e -n "${BOLD}${YELLOW}Step $((++STEP)): ${NC}"
    echo -e "${BOLD}${YELLOW}Creating AUTOCONFIG directories ...${NC}"
    echo -e "${DELIMITER}"

    mkdir -p "$AUTOCONFIG_DIR/backups"
    # This script copies the assets from WSL folder to the AUTOCONFIG_DIR
    # Backup exitig config folder
    if [ -d "$AUTOCONFIG_DIR/config" ]; then
        echo -e "Backing up existing config folder ..."
        echo -e "${YELLOW}Only the latest config will be stored, older configs will be overwritten ...${NC}"
        mv "$AUTOCONFIG_DIR/config" "$AUTOCONFIG_DIR/backups/config_wac_$(date +%Y%m%d%H%M%S).bak"
        echo -e "${YELLOW}Backup stored in ${AUTOCONFIG_DIR}/backups/config.bak${NC}"
    fi
}

copy_config() {
    # Copy the assets to the AUTOCONFIG_DIR
    echo -e "${YELLOW}Copying assets to the autoconfig directory ...${NC}"
    cp -r "$CUR_DIR/wsl/config" "$AUTOCONFIG_DIR"
}

if [ "$SILENT_MODE" = false ]; then
    # shellcheck disable=SC1091
    read -r -p "Proceed with creating AUTOCONFIG backups? [Y/N]  " yn
    case $yn in
        [Yy]* ) backup;;
        [Nn]* ) 
                echo -n "Skipping creating backups ..."
                # shellcheck disable=SC2034
                for i in {1..8}; do echo -n "." && sleep 0.25; done;;
        * ) echo "Please answer Y or N.";;
    esac
else
    backup
fi

copy_config
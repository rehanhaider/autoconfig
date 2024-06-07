#!/bin/bash

configure_bashrc() {
    echo -e "\n"
    echo -e -n "${BOLD}${YELLOW}Step $((++STEP)): ${NC}"
    echo -e "${BOLD}${YELLOW}Configuring .bashrc ...${NC}"
    echo -e "${DELIMITER}"
    echo -e "Backing up existing .bashrc ..."
    mkdir -p "${HOME}/.autoconfig/backups"
    cp "${HOME}/.bashrc" "${HOME}/.autoconfig/backups/.bashrc_wac_$(date +%Y%m%d%H%M%S)"
    # Keep the last MAX_BACKUPS backups, delete the rest. Implement using find and awk
    echo -e "Keeping the last ${MAX_BACKUPS} backups. Older backups will be deleted ..."
    find "${HOME}/.autoconfig/backups" -name ".bashrc_wac_*" -type f | sort -r | awk 'NR>'"${MAX_BACKUPS}" | xargs rm -f
    echo -e "${BOLD}${GREEN}Backed up as ~/.autoconfig/backups/.bashrc_wac_$(date +%Y%m%d%H%M%S)${NC}"
    echo -e "Checking if .bashrc exists ..."
    ## Check if .bashrc exists
    if [ ! -f "${HOME}/.bashrc" ]; then
       touch "${HOME}/.bashrc"
       echo -e "${GREEN}~/.bashrc created${NC}"
    fi
    echo -e "Checking if previous AUTOCONFIG configuration exists ..."
    # Check if # AUTOCONFIG exists in .bashrc
    if grep -q "# AUTOCONFIG" "${HOME}/.bashrc"; then
        echo -e "${RED}Previous AUTOCONFIG configuration found${NC}"
        echo -e "${RED}Removing previous AUTOCONFIG configuration${NC}"
        ## Remove lines that are between "# AUTOCONFIG" and "# END AUTOCONFIG"
        sed -i '/# AUTOCONFIG/,/# END AUTOCONFIG/d' "${HOME}/.bashrc"
    fi


    echo -e "Adding bash config ..."
    { echo "${AUTOCONFIG_START}" ; echo "source ${AUTOCONFIG_DIR}/config/bash/terminal_prompt"; } >> "${HOME}/.bashrc"
    { echo "source ${AUTOCONFIG_DIR}/config/bash/aliases"; echo "${AUTOCONFIG_END}" ; } >> "${HOME}/.bashrc"
}

if [ "$SILENT_MODE" = false ]; then
    # shellcheck disable=SC1091
    read -r -p "Proceed with configuring .bashrc? [Y/N]  " yn
    case $yn in
        [Yy]* ) configure_bashrc;;
        [Nn]* ) 
                echo -n "Skipping configuring .bashrc "
                # shellcheck disable=SC2034
                for i in {1..8}; do echo -n "." && sleep 0.25; done;;
        * ) echo "Please answer Y or N.";;
    esac
else
    configure_bashrc
fi
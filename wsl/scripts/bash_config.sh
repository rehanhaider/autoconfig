#!/bin/bash

configure_bashrc() {
    echo -e "\n"
    rprint "${WARNING}" -n "Step $((++STEP)): "
    rprint "${WARNING}" "Configuring .bashrc..."
    rprint "${WARNING}" "${DELIMITER}"
    rprint "${INFO}" "Backing up existing .bashrc ..."
    if [ ! -d "${AUTOCONFIG_BACKUPS_DIR}/bash" ]; then
        err mkdir -p "${AUTOCONFIG_BACKUPS_DIR}/bash"
    fi
    err cp "${HOME}/.bashrc" "${AUTOCONFIG_BACKUPS_DIR}/bash/.bashrc_wac_$(date +%Y%m%d%H%M%S)"
    # Keep the last MAX_BACKUPS backups, delete the rest. Implement using find and awk
    rprint "${INFO}" "Keeping the last ${MAX_BACKUPS} backups. Older backups will be deleted ..."
    err find "${AUTOCONFIG_BACKUPS_DIR}/bash" -name ".bashrc_wac_*" -type f | sort -r | awk 'NR>'"${MAX_BACKUPS}" | xargs rm -f
    rprint "${INFO}" "Backed up as ${AUTOCONFIG_BACKUPS_DIR}/.bashrc_wac_$(date +%Y%m%d%H%M%S)"
    rprint "${INFO}" "Checking if .bashrc exists ..."
    ## Check if .bashrc exists
    if [ ! -f "${HOME}/.bashrc" ]; then
       err touch "${HOME}/.bashrc"
       rprint "${INFO}" "${HOME}/.bashrc created"
    fi
    rprint "${INFO}" "Checking if previous AUTOCONFIG configuration exists ..."
    # Check if # AUTOCONFIG exists in .bashrc
    if grep -q "# AUTOCONFIG" "${HOME}/.bashrc"; then
        rprint "${INFO}" "Previous AUTOCONFIG configuration found."
        rprint "${INFO}" "Removing previous AUTOCONFIG configuration"
        ## Remove lines that are between "# AUTOCONFIG" and "# END AUTOCONFIG"
        err sed -i '/# AUTOCONFIG/,/# END AUTOCONFIG/d' "${HOME}/.bashrc"
    fi


    rprint "${INFO}" "Adding bash config ..."
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
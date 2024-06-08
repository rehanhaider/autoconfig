#!/bin/bash

# DEFINITIONS

configure_bashrc() {
    INFO "Backing up existing .bashrc ..."
    ## Check if the bash directory exists in AUTOCONFIG_BACKUPS_DIR
    CHECK "bash backup directory" "${AUTOCONFIG_BACKUPS_DIR}/bash"

    INFO "Checking if .bashrc exists ..."
    if [ -f "${HOME}/.bashrc" ]; then
        ## Backup existing .bashrc
        WARN "Existing .bashrc found. Backing up ..."
        RUN "Backup of existing .bashrc" "cp ${HOME}/.bashrc ${AUTOCONFIG_BACKUPS_DIR}/bash/.bashrc_wac_$(date +%Y%m%d%H%M%S)"
    fi
    # Keep the last MAX_BACKUPS backups, delete the rest. Implement using find and awk
    WARN "Keeping the last ${MAX_BACKUPS} backups. Older backups will be deleted ..."
    RUN "Delete older backups" "find ${AUTOCONFIG_BACKUPS_DIR}/bash -name '._wac_*' -type f | sort -r | awk 'NR>${MAX_BACKUPS}' | xargs rm -f"

    ## Check if .bashrc exists
    if [ ! -f "${HOME}/.bashrc" ]; then
        WARN ".bashrc does not exist. Creating ..."
        RUN "Create .bashrc" "touch ${HOME}/.bashrc"
    fi

    INFO "Checking if previous AUTOCONFIG configuration exists ..."
    # Check if # AUTOCONFIG exists in .bashrc
    if grep -q "# AUTOCONFIG" "${HOME}/.bashrc"; then
        INFO "Previous AUTOCONFIG configuration found."
        WARN "Removing previous AUTOCONFIG configuration"
        ## Remove lines that are between "# AUTOCONFIG" and "# END AUTOCONFIG"
        RUN "Remove previous AUTOCONFIG configuration" "sed -i '/# AUTOCONFIG/,/# END AUTOCONFIG/d' ${HOME}/.bashrc"
    fi


    WARN "Configuring bash settings..."
    # shellcheck disable=SC2129
    RUN "Add AUTOCONFIG start tag" "echo '${AUTOCONFIG_START}' >> ${HOME}/.bashrc"
    RUN "Add terminal prompt configuration" "echo 'source ${AUTOCONFIG_DIR}/config/bash/terminal_prompt' >> ${HOME}/.bashrc"
    RUN "Add aliases configuration" "echo 'source ${AUTOCONFIG_DIR}/config/bash/aliases' >> ${HOME}/.bashrc"
    RUN "Add export configuration" "echo 'source ${AUTOCONFIG_DIR}/config/bash/exports' >> ${HOME}/.bashrc"
    RUN "Add AUTOCONFIG end tag" "echo '${AUTOCONFIG_END}' >> ${HOME}/.bashrc"
}

# MAIN

## Prompt the user to configure .bashrc
DELIM "Configuring .bashrc..."
PROMPT "configuring .bashrc" configure_bashrc
NEWLINE
PASS "Configured .bashrc successfully."
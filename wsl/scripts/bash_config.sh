#!/bin/bash

# DEFINITIONS

configure_bashrc() {
    INFO "Backing up existing .bashrc ..."
    ## Check if the bash directory exists in AUTOCONFIG_BACKUPS_DIR
    if [ ! -d "${AUTOCONFIG_BACKUPS_DIR}/bash" ]; then
        FAIL "bash backup directory does not exist. preapre_wac.sh script must be run first."
        FAIL "Advised to redownload AUTOCONFIG. and try again."
        exit 1
    fi

    INFO "Checking if .bashrc exists ..."
    if [ -f "${HOME}/.bashrc" ]; then
        ## Backup existing .bashrc
        WARN "Existing .bashrc found. Backing up ..."
        if err cp "${HOME}/.bashrc" "${AUTOCONFIG_BACKUPS_DIR}/bash/.bashrc_wac_$(date +%Y%m%d%H%M%S)"; then
            PASS "Backed up as ${AUTOCONFIG_BACKUPS_DIR}/bash/.bashrc_wac_$(date +%Y%m%d%H%M%S)"
        else
            FAIL "Failed to backup .bashrc. Please ensure you have the necessary permissions. Exiting ..."
            exit 1
        fi
    fi
    # Keep the last MAX_BACKUPS backups, delete the rest. Implement using find and awk
    WARN "Keeping the last ${MAX_BACKUPS} backups. Older backups will be deleted ..."
    if err find "${AUTOCONFIG_BACKUPS_DIR}/bash" -name "._wac_*" -type f | sort -r | awk 'NR>'"${MAX_BACKUPS}" | xargs rm -f; then
        PASS "Older backups deleted successfully."
    else
        FAIL "Failed to delete older backups. Please ensure you have the necessary permissions. Exiting ..."
        exit 1
    fi

    ## Check if .bashrc exists
    if [ ! -f "${HOME}/.bashrc" ]; then
        WARN ".bashrc does not exist. Creating ..."
        if err touch "${HOME}/.bashrc"; then
            PASS "${HOME}/.bashrc created"
        else
            FAIL "Failed to create .bashrc. Please ensure you have the necessary permissions. Exiting ..."
            exit 1
        fi
    fi

    INFO "Checking if previous AUTOCONFIG configuration exists ..."
    # Check if # AUTOCONFIG exists in .bashrc
    if grep -q "# AUTOCONFIG" "${HOME}/.bashrc"; then
        INFO "Previous AUTOCONFIG configuration found."
        WARN "Removing previous AUTOCONFIG configuration"
        ## Remove lines that are between "# AUTOCONFIG" and "# END AUTOCONFIG"
        if err sed -i '/# AUTOCONFIG/,/# END AUTOCONFIG/d' "${HOME}/.bashrc"; then
            PASS "Previous AUTOCONFIG configuration removed successfully."
        else
            FAIL "Failed to remove previous AUTOCONFIG configuration. Please check if you have the necessary permissions. If needed visually inspect the ~/.bashrc file. Exiting ..."
            exit 1
        fi
    fi


    INFO "Configuring bash settings..."
    # shellcheck disable=SC2129
    if echo "${AUTOCONFIG_START}" >> "${HOME}/.bashrc"; then
        PASS "Added AUTOCONFIG start tag"
    else
        FAIL "Failed to add AUTOCONFIG start tag. Please ensure you have the necessary permissions. Exiting ..."
        exit 1
    fi
    if echo "source ${AUTOCONFIG_DIR}/config/bash/terminal_prompt" >> "${HOME}/.bashrc"; then
        PASS "Added terminal prompt configuration"
    else
        FAIL "Failed to add terminal prompt configuration. Please ensure you have the necessary permissions. Exiting ..."
        exit 1
    fi
    if echo "source ${AUTOCONFIG_DIR}/config/bash/aliases" >> "${HOME}/.bashrc"; then
        PASS "Added aliases configuration"
    else
        FAIL "Failed to add aliases configuration. Please ensure you have the necessary permissions. Exiting ..."
        exit 1
    fi
    if echo "${AUTOCONFIG_END}" >> "${HOME}/.bashrc"; then
        PASS "Added AUTOCONFIG end tag"
    else
        FAIL "Failed to add AUTOCONFIG end tag. Please ensure you have the necessary permissions. Exiting ..."
        exit 1
    fi
}

# MAIN

## Prompt the user to configure .bashrc
print_delimiter "Configuring .bashrc..."
prompt_and_execute "configuring .bashrc" configure_bashrc
NEWLINE
PASS "Configured .bashrc successfully."
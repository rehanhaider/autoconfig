#!/bin/bash

theme="quick-term-custom.omp.json"

backup_theme() {
    WARN "Backing up existing theme..."
    if err cp "${AUTOCONFIG_DIR}/poshthemes/$theme" "${AUTOCONFIG_BACKUPS_DIR}/poshthemes/.${theme}_wac_$(date +%Y%m%d%H%M%S)"; then
        PASS "Theme backed up successfully ..."
    else
        FAIL "Failed to backup theme. Exiting ..."
        exit 1
    fi
    WARN "Keeping the last ${MAX_BACKUPS} backups. Older backups will be deleted ..."
    if err find "${AUTOCONFIG_BACKUPS_DIR}/poshthemes" -name "._wac_*" -type f | sort -r | awk 'NR>'"${MAX_BACKUPS}" | xargs rm -f; then
        PASS "Older backups deleted successfully."
    else
        FAIL "Failed to delete older backups. Please ensure you have the necessary permissions. Exiting ..."
        exit 1
    fi

}

overwrite_theme() {
    WARN "Overwriting theme ..."
    if err cp "${THEME_DIR}/$theme" "${AUTOCONFIG_DIR}/poshthemes/"; then
        PASS "Theme overwritten successfully ..."
    else
        FAIL "Failed to overwrite theme. Exiting ..."
        exit 1
    fi
}


install_omp() {
    ## Check if Oh My Posh binary exists
    if [ ! -f /usr/local/bin/oh-my-posh ]; then
        WARN "Oh My Posh binary does not exist..."
        ## Install Oh My Posh
        WARN "Installing Oh My Posh from source..."
        if err curl -s https://ohmyposh.dev/install.sh > "${SCRIPTS_DIR}/omp_install.sh"; then
            PASS "Oh My Posh install script downloaded ..."
        else
            FAIL "Failed to download Oh My Posh install script. Exiting ..."
            exit 1
        fi
        if err chmod +x "${SCRIPTS_DIR}/omp_install.sh"; then
            PASS "Oh My Posh install script is executable ..."
        else
            FAIL "Failed to make Oh My Posh install script executable. Exiting ..."
            exit 1
        fi
        if err sudo "${SCRIPTS_DIR}/omp_install.sh"; then
            PASS "Oh My Posh installed successfully ..."
        else
            FAIL "Failed to install Oh My Posh. Exiting ..."
            exit 1
        fi
        if err rm "${SCRIPTS_DIR}/omp_install.sh"; then
            PASS "Oh My Posh install script removed ..."
        else
            WARN "Failed to remove Oh My Posh install script. Please remove it manually ..."
        fi
    fi
}


configure_omp() {
 
    INFO "Configuring theme..."
    ## Create a theme folder
    if [ ! -d "${AUTOCONFIG_DIR}/poshthemes" ]; then
        FAIL "Themes directory does not exist. preapre_wac.sh script must be run first."
        FAIL "Advised to redownload AUTOCONFIG and try again."
        exit 1
    fi
    INFO "Checking if theme exists ..."
    ## Check if the theme exists
    if [ ! -f "${AUTOCONFIG_DIR}/poshthemes/$theme" ]; then
        INFO "Installing Theme: $theme ..."
        ## Copy the theme to the folder
        if err cp "${THEME_DIR}/$theme" "${AUTOCONFIG_DIR}/poshthemes/"; then
            PASS "Theme installed successfully ..."
        else
            FAIL "Failed to install theme. Exiting ..."
            exit 1
        fi
    else
        INFO "Found Theme: $theme ..."
        INFO "Comparing with source version..."
        # Check if the theme is the same
        if ! cmp -s "${AUTOCONFIG_DIR}/poshthemes/$theme" "${THEME_DIR}/$theme"; then
            FAIL "Updated $theme available."
            if [ "$SILENT_MODE" = false ]; then
                # shellcheck disable=SC1091
                while true; do
                    NEWLINE
                    read -r -p "Do you want to overwrite the theme with the one from source? [Y/N]  " yn
                    case $yn in
                        [Yy]* )
                                backup_theme
                                overwrite_theme
                                break;;
                        [Nn]* ) 
                                INFO -n "Skipping overwriting theme "
                                # shellcheck disable=SC2034
                                for i in {1..8}; do echo -n "." && sleep 0.25; done; 
                                NEWLINE
                                break;;
                        * ) echo "Please answer Y or N.";;
                    esac
                done
            else
                backup_theme
                overwrite_theme
            fi
        fi
        PASS "Latest theme is installed ..."
    fi
    if [ ! -d "${AUTOCONFIG_BACKUPS_DIR}/profile" ]; then
        FAIL "Profile backups directory does not exist. preapre_wac.sh script must be run first."
        FAIL "Advised to redownload AUTOCONFIG and try again."
        exit 1
    fi

    WARN "Backing up .profile"
    if err cp "${HOME}/.profile" "${AUTOCONFIG_BACKUPS_DIR}/profile/._wac_$(date +%Y%m%d%H%M%S)"; then
        PASS "Profile backed up successfully ..."
    else
        FAIL "Failed to backup profile. Exiting ..."
        exit 1
    fi
    
    WARN "Keeping the last ${MAX_BACKUPS} backups. Older backups will be deleted ..."
    if err find "${AUTOCONFIG_BACKUPS_DIR}/profile" -name "._wac_*" -type f | sort -r | awk 'NR>'"${MAX_BACKUPS}" | xargs rm -f; then
        PASS "Older backups deleted successfully."
    else
        FAIL "Failed to delete older backups. Please ensure you have the necessary permissions. Exiting ..."
        exit 1
    fi

    ## Check if the the theme name exists in the .profile
    if grep -q "$theme" "${HOME}/.profile"; then
        WARN "Removing older AUTOCONFIG data"
        ## Remove lines that are between "# AUTOCONFIG" and "# END AUTOCONFIG"
        if err sed -i '/# AUTOCONFIG/,/# END AUTOCONFIG/d' "${HOME}/.profile"; then
            PASS "Previous AUTOCONFIG configuration removed successfully."
        else
            FAIL "Failed to remove previous AUTOCONFIG configuration. Please check if you have the necessary permissions. If needed visually inspect the ~/.profile file. Exiting ..."
            exit 1
        fi
    fi
        ## Add the theme name to the .profile
    export WSL_ACFG_OMP_THEME=$theme
    if echo "${AUTOCONFIG_START}" >> "${HOME}/.profile"; then
        PASS "AUTOCONFIG start marker added to .profile"
    else
        FAIL "Failed to add AUTOCONFIG start marker to .profile. Exiting ..."
        exit 1
    fi
    if echo "eval \"\$(oh-my-posh init bash --config ~/.poshthemes/$theme)\"" >> ~/.profile; then
        PASS "Oh My Posh configuration added to .profile"
    else
        FAIL "Failed to add Oh My Posh configuration to .profile. Exiting ..."
        exit 1
    fi
    if echo "${AUTOCONFIG_END}" >> "${HOME}/.profile"; then
        PASS "AUTOCONFIG end marker added to .profile"
    else
        FAIL "Failed to add AUTOCONFIG end marker to .profile. Exiting ..."
        exit 1
    fi
}

print_delimiter "Installing Oh My Posh..."
prompt_and_execute "installation of Oh My Posh" install_omp
NEWLINE
PASS "Installed Oh My Posh successfully"


print_delimiter "Configuring Oh My Posh..."
prompt_and_execute "configuration of Oh My Posh" configure_omp
NEWLINE
PASS "Configured Oh My Posh successfully."
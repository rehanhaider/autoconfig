#!/bin/bash



backup_theme() {
    WARN "Backing up existing theme..."
    RUN "Theme backup" "cp ${AUTOCONFIG_DIR}/poshthemes/$AUTOCONFIG_OMP_THEME_NAME ${AUTOCONFIG_BACKUPS_DIR}/poshthemes/.${AUTOCONFIG_OMP_THEME_NAME}_wac_$(date +%Y%m%d%H%M%S)"
    WARN "Keeping the last ${MAX_BACKUPS} backups. Older backups will be deleted ..."
    RUN "Delete older backups" "find ${AUTOCONFIG_BACKUPS_DIR}/poshthemes -name '._wac_*' -type f | sort -r | awk 'NR>${MAX_BACKUPS}' | xargs rm -f"
}

overwrite_theme() {
    WARN "Overwriting theme ..."
    RUN "Overwrite theme" "cp ${THEME_DIR}/$AUTOCONFIG_OMP_THEME_NAME ${AUTOCONFIG_DIR}/poshthemes/"
}


install_omp() {
    ## Check if Oh My Posh binary exists
    if [ ! -f /usr/local/bin/oh-my-posh ]; then
        WARN "Oh My Posh binary does not exist..."
        ## Install Oh My Posh
        WARN "Installing Oh My Posh from source..."
        RUN "Download Oh My Posh install script" "curl -s https://ohmyposh.dev/install.sh > ${SCRIPTS_DIR}/omp_install.sh"
        RUN "Make Oh My Posh install script executable" "chmod +x ${SCRIPTS_DIR}/omp_install.sh"
        RUN "Install Oh My Posh" "sudo ${SCRIPTS_DIR}/omp_install.sh"
        RUN "Remove Oh My Posh install script" "rm ${SCRIPTS_DIR}/omp_install.sh"
    fi
}


configure_omp() {
 
    INFO "Configuring theme..."
    CHECK "Themes directory" "${AUTOCONFIG_DIR}/poshthemes"

    INFO "Checking if theme exists ..."
    ## Check if the theme exists
    if [ ! -f "${AUTOCONFIG_DIR}/poshthemes/$AUTOCONFIG_OMP_THEME_NAME" ]; then
        INFO "Installing Theme: $AUTOCONFIG_OMP_THEME_NAME ..."
        ## Copy the theme to the folder
        RUN "Copy theme folder" "cp ${THEME_DIR}/$AUTOCONFIG_OMP_THEME_NAME ${AUTOCONFIG_DIR}/poshthemes/"
    else
        INFO "Found Theme: $AUTOCONFIG_OMP_THEME_NAME ..."
        INFO "Comparing with source version..."
        # Check if the theme is the same
        if ! cmp -s "${AUTOCONFIG_DIR}/poshthemes/$AUTOCONFIG_OMP_THEME_NAME" "${THEME_DIR}/$AUTOCONFIG_OMP_THEME_NAME"; then
            FAIL "Updated $AUTOCONFIG_OMP_THEME_NAME available."
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
    ## Check if Profile backup directory exists
    CHECK "Oh My Posh configuration" "${AUTOCONFIG_BACKUPS_DIR}/profile"

    WARN "Backing up .profile"
    RUN "Profile backup" "cp ${HOME}/.profile ${AUTOCONFIG_BACKUPS_DIR}/profile/._wac_$(date +%Y%m%d%H%M%S)"
    
    WARN "Keeping the last ${MAX_BACKUPS} backups. Older backups will be deleted ..."
    RUN "Delete older backups" "find ${AUTOCONFIG_BACKUPS_DIR}/profile -name '._wac_*' -type f | sort -r | awk 'NR>${MAX_BACKUPS}' | xargs rm -f"

    ## Check if the the theme name exists in the .profile
    if grep -q "$AUTOCONFIG_OMP_THEME_NAME" "${HOME}/.profile"; then
        WARN "Removing older AUTOCONFIG data"
        ## Remove lines that are between "# AUTOCONFIG" and "# END AUTOCONFIG"
        RUN "Remove previous AUTOCONFIG configuration" "sed -i '/# AUTOCONFIG/,/# END AUTOCONFIG/d' ${HOME}/.profile"
    fi
    ## Add the theme name to the .profile
    RUN "AUTOCONFIG start marker" "echo '${AUTOCONFIG_START}' >> ${HOME}/.profile"
    # shellcheck disable=SC2016
    RUN "Profile OMP config" "echo source '${AUTOCONFIG_DIR}/config/profile/omp_prompt' >> ${HOME}/.profile"
    RUN "AUTOCONFIG end marker" "echo '${AUTOCONFIG_END}' >> ${HOME}/.profile"
}

DELIM "Installing Oh My Posh..."
PROMPT "installation of Oh My Posh" install_omp
NEWLINE
PASS "Installed Oh My Posh successfully"


DELIM "Configuring Oh My Posh..."
PROMPT "configuration of Oh My Posh" configure_omp
NEWLINE
PASS "Configured Oh My Posh successfully."
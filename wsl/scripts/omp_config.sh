#!/bin/bash

configure_omp() {
    theme="quick-term-custom.omp.json"
    ## Check if Oh My Posh binary exists
    if [ ! -f /usr/local/bin/oh-my-posh ]; then
        INFO "Oh My Posh binary does not exist..."
        ## Install Oh My Posh
        INFO "Installing Oh My Posh from source..."
        err curl -s https://ohmyposh.dev/install.sh > "${SCRIPTS_DIR}/omp_install.sh"
        err chmod +x "${SCRIPTS_DIR}/omp_install.sh"
        err sudo "${SCRIPTS_DIR}/omp_install.sh"
        err rm "${SCRIPTS_DIR}/omp_install.sh"
    fi
    INFO "Oh My Posh is installed ..."
    INFO "Installing theme ..."
    ## Create a theme folder
    if [ ! -d "${AUTOCONFIG_DIR}/poshthemes" ]; then
        err mkdir "${AUTOCONFIG_DIR}/poshthemes"
    else
        INFO "${AUTOCONFIG_DIR}/poshthemes already exists ..."
    fi
    INFO "Configuring theme ..."
    ## Check if the theme exists
    if [ ! -f "${AUTOCONFIG_DIR}/poshthemes/$theme" ]; then
        INFO "Installing Theme: $theme ..."
        ## Copy the theme to the folder
        err cp "${THEME_DIR}/$theme" "${AUTOCONFIG_DIR}/poshthemes"
    else
        INFO "Found Theme: $theme ..."
        INFO "Checking for updates in theme ..."
        # Check if the theme is the same
        if ! cmp -s "${AUTOCONFIG_DIR}/poshthemes/$theme" "${THEME_DIR}/$theme"; then
            INFO "Updated $theme available. Installing ..."
            err cp "${THEME_DIR}/$theme" "${AUTOCONFIG_DIR}/.poshthemes"
        fi
        INFO "Latest theme is installed ..."
    fi
    if [ ! -d "${AUTOCONFIG_BACKUPS_DIR}/profile" ]; then
        err mkdir -p "${AUTOCONFIG_BACKUPS_DIR}/profile"
    fi
    INFO "Backing up .profile"
    err cp "${HOME}/.profile" "${AUTOCONFIG_BACKUPS_DIR}/profile/.profile_wac_$(date +%Y%m%d%H%M%S)"

    ## Check if the the theme name exists in the .profile
    if grep -q "$theme" "${HOME}/.profile"; then
        INFO "Removing older AUTOCONFIG data"
        ## Remove lines that are between "# AUTOCONFIG" and "# END AUTOCONFIG"
        err sed -i '/# AUTOCONFIG/,/# END AUTOCONFIG/d' "${HOME}/.profile"
    fi
        ## Add the theme name to the .profile
    export WSL_ACFG_OMP_THEME=$theme
    echo "${AUTOCONFIG_START}" >> "${HOME}/.profile"
    echo "eval \"\$(oh-my-posh init bash --config ~/.poshthemes/$theme)\"" >> ~/.profile
    echo "${AUTOCONFIG_END}" >> "${HOME}/.profile"
}



echo -e "\n"
WARN -n "Step $((++STEP)): "
WARN "Configuring Oh My Posh..."
WARN "${DELIMITER}"


if [ "$SILENT_MODE" = false ]; then
    # shellcheck disable=SC1091
    read -r -p "Proceed with configuring Oh My Posh? [Y/N]  " yn
    case $yn in
        [Yy]* ) configure_omp;;
        [Nn]* ) 
                echo -n "Skipping configuring Oh My Posh "
                # shellcheck disable=SC2034
                for i in {1..8}; do echo -n "." && sleep 0.25; done;;
        * ) echo "Please answer Y or N.";;
    esac
else
    configure_omp
fi
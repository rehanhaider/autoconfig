#!/bin/bash

configure_omp() {
    theme="quick-term-custom.omp.json"
    echo -e "\n"
    echo -e -n "${BOLD}${YELLOW}Step $((++STEP)): ${NC}"
    echo -e "${BOLD}${YELLOW}Configuring Oh My Posh ...${NC}"
    echo -e "${DELIMITER}"
    ## Check if Oh My Posh binary exists
    if [ ! -f /usr/local/bin/oh-my-posh ]; then
        echo -e "${BOLD}${RED}Oh My Posh binary does not exist ...${NC}"
        ## Install Oh My Posh
        echo "Installing Oh My Posh from source..."
        curl -s https://ohmyposh.dev/install.sh > omp_install.sh
        chmod +x omp_install.sh
        sudo ./omp_install.sh
        rm ./omp_install.sh
    fi
    echo "Oh My Posh is installed ..."
    echo "Installing theme ..."
    ## Create a theme folder
    if [ ! -d "${HOME}/.poshthemes" ]; then
        mkdir "${HOME}/.poshthemes"
    else
        echo -e "${HOME}/.poshthemes already exists ..."
    fi
    echo -e "Configuring theme ..."
    ## Check if the theme exists
    if [ ! -f "${HOME}/.poshthemes/$theme" ]; then
        echo "Installing Theme: $theme ..."
        ## Copy the theme to the folder
        cp "${CUR_DIR}/themes/$theme" "${HOME}/.poshthemes"
    else
        echo "Found Theme: $theme ..."
        echo "Checking for updates in theme ..."
        # Check if the theme is the same
        if ! cmp -s "${HOME}/.poshthemes/$theme" "${CUR_DIR}/themes/$theme"; then
            echo "Updated $theme available. Installing ..."
            cp "${CUR_DIR}/themes/$theme" "${HOME}/.poshthemes"
        fi
        echo "Latest theme is installed ..."
    fi

    ## Check if the the theme name exists in the .profile
    if grep -q "$theme" "${HOME}/.profile"; then
        echo -e "Removing older AUTOCONFIG data"
        ## Remove lines that are between "# AUTOCONFIG" and "# END AUTOCONFIG"
        sed -i '/# AUTOCONFIG/,/# END AUTOCONFIG/d' "${HOME}/.profile"
    fi
        ## Add the theme name to the .profile
    export WSL_ACFG_OMP_THEME=$theme
    echo "${AUTOCONFIG_START}" >> "${HOME}/.profile"
    echo "eval \"\$(oh-my-posh init bash --config ~/.poshthemes/$theme)\"" >> ~/.profile
    echo "${AUTOCONFIG_END}" >> "${HOME}/.profile"
}

if [ "$SILENT_MODE" = false ]; then
    # shellcheck disable=SC1091
    read -r -p "Proceed with configuring Oh My Posh? [Y/N]  " yn
    case $yn in
        [Yy]* ) configure_bashrc;;
        [Nn]* ) 
                echo -n "Skipping configuring Oh My Posh "
                # shellcheck disable=SC2034
                for i in {1..8}; do echo -n "." && sleep 0.25; done;;
        * ) echo "Please answer Y or N.";;
    esac
else
    configure_omp
fi
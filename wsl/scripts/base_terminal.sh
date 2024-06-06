#!/bin/bash

configure_bashrc() {
    echo -e "\n"
    echo -e -n "${BOLD}${YELLOW}Step $((++STEP)): ${NC}"
    echo -e "${BOLD}${YELLOW}Configuring .bashrc ...${NC}"
    echo -e "${DELIMITER}"
    echo -e "Copying terminal prompt configuration to .bashrc ..."
    echo -e "Checking if .bashrc exists ..."
    ## Check if .bashrc exists
    if [ ! -f ~/.bashrc ]; then
        echo "${BOLD}${RED}File .bashrc does not exist ...${NC}"
        read -r -p "Do you want to create .bashrc? [Y/N] " yn
        case $yn in
            [Yy]* ) 
                    touch ~/.bashrc
                    echo -e "${GREEN}~/.bashrc created${NC}";;
            [Nn]* ) 
                echo -e "${BOLD}${RED}Skipping configuring .bashrc ...${NC}";;
            * ) echo "Please answer Y or N.";;
        esac
    else
        echo -e "File .bashrc exists ..."
    fi
    echo -e "Checking if previous AUTOCONFIG configuration exists ..."
    ## Check if the function __bash_prompt() already exists the the file
    if grep -q "__bash_prompt()" ~/.bashrc; then
        echo -e "Removing older AUTOCONFIG data"
        ## Remove lines that are between "# AUTOCONFIG" and "# END AUTOCONFIG"
        sed -i '/# AUTOCONFIG/,/# END AUTOCONFIG/d' ~/.bashrc
    fi
    echo -e "Creating backup of ~/.bashrc"
    cp ~/.bashrc ~/.bashrc_bck
    echo -e "${BOLD}${GREEN}Backed up as ~/.bashrc_bck${NC}"

    echo -e "Adding bash config ..."
    cat "$CUR_DIR/wsl/static/terminal_prompt.sh" >> ~/.bashrc
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
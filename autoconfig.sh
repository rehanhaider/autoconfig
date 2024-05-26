#!/bin/bash

# Update packages

## Print message in green color
echo -e "\e[32mUpdating packages\e[0m"
sudo apt update -y && sudo apt upgrade -y

# Configure Terminal Prompt
echo -e "\e[32mConfiguring Terminal Prompt\e[0m"

## Check if .bashrc exists
if [ ! -f ~/.bashrc ]; then
    echo "File .bashrc does not exist"
    exit 1
fi

## Check if the function __bash_prompt() already exists the the file
if grep -q "__bash_prompt()" ~/.bashrc; then
    ## if the function exists, remove it
    sed -i '/__bash_prompt()/,/^}/d' ~/.bashrc

    # ## Remove the line that calls the function
    # sed -i '/__bash_prompt/d' ~/.bashrc

    # ## Remove the line that sets the PROMPT_DIRTRIM
    # sed -i '/PROMPT_DIRTRIM/d' ~/.bashrc

    ## Remove lines that are between "# AUTOCONFIG" and "# END AUTOCONFIG"
    sed -i '/# AUTOCONFIG/,/# END AUTOCONFIG/d' ~/.bashrc

fi

## Add the function __bash_prompt() to the file
cat ./configs/terminal_prompt >> ~/.bashrc

## Reload the .bashrc file
source ~/.bashrc

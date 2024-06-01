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

    ## Remove lines that are between "# AUTOCONFIG" and "# END AUTOCONFIG"
    sed -i '/# AUTOCONFIG/,/# END AUTOCONFIG/d' ~/.bashrc

fi

## Add the function __bash_prompt() to the file
cat ./configs/wsl/terminal_prompt >> ~/.bashrc

## Check if Oh My Posh binary exists
if [ ! -f /usr/local/bin/oh-my-posh ]; then
    echo "Oh My Posh binary does not exist"
    ## Install Oh My Posh
    echo "Installing Oh My Posh"
    curl -s https://ohmyposh.dev/install.sh > install.sh
    chmod +x install.sh
    sudo ./install.sh
fi


## Create a theme folder
if [ ! -d ~/.poshthemes ]; then
    mkdir ~/.poshthemes
fi

theme="quick-term-custom.omp.json"

## Check if the theme exists
if [ ! -f "~/.poshthemes/$theme" ]; then
    echo "Theme $theme does not exist"
    ## Copy the theme to the folder
    cp ./themes/$theme ~/.poshthemes
else
    echo "Theme $theme already exists"
    # Check if the theme is the same
    if ! cmp -s ~/.poshthemes/$theme ./themes/$theme; then
        echo "Theme $theme is different"
        cp ./themes/$theme ~/.poshthemes
    fi
fi

## Check if the the theme name exists in the .profile
if ! grep -q "$theme" ~/.profile; then
    ## Add the theme name to the .profile
    echo "eval \"\$(oh-my-posh init bash --config ~/.poshthemes/$theme)\"" >> ~/.profile
fi

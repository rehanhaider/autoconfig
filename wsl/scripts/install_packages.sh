#!/bin/bash

# DEFINITIONS
## Update apt packages
update_packages() {
    RUN "Update" "sudo apt update -y"
}

upgrade_packages() {
    RUN "Upgrade" "sudo apt upgrade -y"
}

install_bat() {
    RUN "Install bat" "sudo apt install -y bat"
    RUN "Create directory for symlink" "mkdir -p ~/.local/bin"
    RUN "Create symlink" "ln -s /usr/bin/batcat ~/.local/bin/bat"
}


install_nvim() {
    RUN "add nvim repository" "sudo add-apt-repository ppa:neovim-ppa/stable"
    RUN "update apt" "sudo apt update"
    RUN "install nvim" "sudo apt install -y neovim"
    RUN "Install python modules" "sudo apt install -y python3-pip python3-dev"
}

install_zoxide() {
    RUN "install zoxide" "curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh"
}

## Install required packages
install_packages() {
    RUN "Installoig required packages" "sudo apt install -y curl nano wget unzip git gcc g++ make build-essential jq bind9-dnsutils whois tmux postgresql-client-17"
    RUN "Installing required packages" "sudo apt install -y fzf"
    RUN "Installing bat" install_bat
    RUN "Installing nvim" install_nvim
    RUN "Installing zoxide" install_zoxide
}





# MAIN

## Prompt the user to update packages
DELIM "Updating apt packages..."
PROMPT "updating apt packages" update_packages
NEWLINE
PASS "Packages updated successfully."

DELIM "Upgrading apt packages..."
PROMPT "upgrading apt packages" upgrade_packages
NEWLINE
PASS "Packages upgraded successfully."

## Prompt the user to install required packages
DELIM "Installing required packages..."
PROMPT "installing required packages" install_packages
NEWLINE
PASS "Required packages installed successfully."

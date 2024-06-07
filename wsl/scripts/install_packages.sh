#!/bin/bash

# DEFINITIONS
## Update apt packages
update_packages() {
    run_command "Update" "sudo apt update -y"
}

upgrade_packages() {
    run_command "Upgrade" "sudo apt upgrade -y"
}

## Install required packages
install_packages() {
    run_command "Installation" "sudo apt install -y curl nano wget"
}

# MAIN

## Prompt the user to update packages
print_delimiter "Updating apt packages..."
prompt_and_execute "updating apt packages" update_packages
NEWLINE
PASS "Packages updated successfully."

print_delimiter "Upgrading apt packages..."
prompt_and_execute "upgrading apt packages" upgrade_packages
NEWLINE
PASS "Packages upgraded successfully."

## Prompt the user to install required packages
print_delimiter "Installing required packages..."
prompt_and_execute "installing required packages" install_packages
NEWLINE
PASS "Required packages installed successfully."
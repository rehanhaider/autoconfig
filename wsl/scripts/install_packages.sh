#!/bin/bash

# DEFINITIONS
## Update apt packages
update_packages() {
    err sudo apt update -y
}

upgrade_packages() {
    err sudo apt upgrade -y
    INFO "Packages upgraded successfully."
}

## Install required packages
install_packages() {
    err sudo apt install -y curl nano wget
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
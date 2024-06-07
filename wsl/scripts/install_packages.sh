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
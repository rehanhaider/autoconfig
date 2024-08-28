#!/bin/bash


# DEFINITIONS
## Update apt packages
install_uv() {
    RUN "Install" "curl -LsSf https://astral.sh/uv/install.sh | sh"
    RUN "Reload bash" "source ~/.bashrc"
}

## Prompt the user to update packages
DELIM "Installing UV..."
PROMPT "Installing UV" install_uv
NEWLINE
PASS "UV installed successfully."
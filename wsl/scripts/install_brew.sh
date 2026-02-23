#!/bin/bash

install_brew() {
    INFO "Installing brew..."
    RUN "Install brew" "/bin/bash -c $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

# MAIN
DELIM "Installing brew..."
PROMPT "Installing brew" install_brew
NEWLINE
PASS "Installed brew successfully."


#!/bin/bash

brew_binary() {
    if command -v brew >/dev/null 2>&1; then
        command -v brew
    elif [ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
        echo "/home/linuxbrew/.linuxbrew/bin/brew"
    else
        return 1
    fi
}

install_brew() {
    local brew_path
    if brew_path=$(brew_binary); then
        PASS "Homebrew is already installed at ${brew_path}. Skipping..."
        return 0
    fi

    INFO "Installing brew..."
    RUN "Create local bin directory" "mkdir -p ${HOME}/.local/bin"
    RUN "Install brew" 'env NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
}

# MAIN
DELIM "Installing brew..."
PROMPT "Installing brew" install_brew
NEWLINE
PASS "Installed brew successfully."

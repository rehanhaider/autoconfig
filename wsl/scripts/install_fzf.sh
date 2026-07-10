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

install_fzf() {
    local brew_path
    if ! brew_path=$(brew_binary); then
        FAIL "Homebrew is not installed. install_brew.sh must run before install_fzf.sh."
        exit 1
    fi

    eval "$("${brew_path}" shellenv)"

    if command -v fzf >/dev/null 2>&1; then
        PASS "fzf is already installed. Skipping..."
    else
        RUN "Install fzf" "brew install fzf"
    fi
}

DELIM "Installing fzf..."
PROMPT "Installing fzf" install_fzf
NEWLINE
PASS "Installed fzf successfully."

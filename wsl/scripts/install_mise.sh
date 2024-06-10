#!/bin/bash

install_mise() {
    ## Check if mise is already installed
    if [ -f "${HOME}/.local/bin/mise" ]; then
        PASS "mise is already installed. Skipping..."
    else 
        RUN "Install mise" "curl https://mise.run | sh"
    fi
}

install_mise_langs() {
    ## Check if node is already installed
    RUN "Install latest Node.js & NPM" "${HOME}/.local/bin/mise use --global node@latest"
    RUN "Set Mise to compile python" "${HOME}/.local/bin/mise settings set python_compile 1"
    RUN "Install latest Node.js & NPM" "${HOME}/.local/bin/mise use --global python@3.12"
}

## Prompt the user to configure .bashrc
DELIM "Installing mise..."
PROMPT "Installing mise" install_mise
NEWLINE
PASS "Installed mise successfully."

DELIM "Installing latest NodeJS, NPM, and Python..."
PROMPT "Installing NodeJS, NPM, and Python" install_mise_langs
NEWLINE
PASS "Installed mise successfully."
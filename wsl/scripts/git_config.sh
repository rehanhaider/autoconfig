#!/bin/bash

git_config() {
    INFO "Configuration you git profile..."

    # Check if git is installed
    if ! command -v git &> /dev/null; then
        FAIL "Git is not installed. Please install git first."
        exit 1
    fi

    ## Check if git global config already has a user.email
    if git config --global user.email &> /dev/null; then
        INFO "Git user.email already configured."
    else
        read -r -p "Email that you use with git: " email
        git config --global user.email "${email}"
    fi

    ## Check if git global config already has a user.name
    if git config --global user.name &> /dev/null; then
        INFO "Git user.name already configured."
    else
        read -r -p "You name that you use with git: " name
        git config --global user.name "${name}"
    fi
    
}

setup_cred() {
    INFO "Configuring git credential helper..."
    # CHeck the git version
    git_version=$(git --version | awk '{print $3}')

    ## If the git version is greate than 2.39.0
    if dpkg --compare-versions "${git_version}" gte "2.39.0"; then
        git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"
    elif dpkg --compare-versions "${git_version}" gte "2.36.1"; then
        git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/libexec/git-core/git-credential-manager.exe"
    elif dpkg --compare-versions "${git_version}" lt "2.36.1"; then
        git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager-core.exe"
    else
        FAIL "Git version v${git_version} is not supported. Please upgrade to git version 2.36.1 or greater."
        exit 1
    fi
    

}

DELIM "Configuring git"
PROMPT "Configuration of git" git_config
NEWLINE
PASS "Configured git successfully"

DELIM "Setting up git credential helper"
PROMPT "Setting up git credential helper" setup_cred
NEWLINE
PASS "Configured git credential helper successfully"
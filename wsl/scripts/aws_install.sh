#!/bin/bash

install_aws_cli() {
    ## Check if AWS CLI is already installed
    if [ -f "/usr/local/bin/aws" ]; then
        PASS "AWS CLI is already installed. Skipping..."
    else 
        RUN "Install AWS CLI" "curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip'"
        RUN "Unzip AWS CLI" "unzip awscliv2.zip"
        RUN "Install AWS CLI" "sudo ./aws/install"
        RUN "Clean up" "rm -rf aws awscliv2.zip"
    fi
}

link_win_credentials() {
    WIN_USER=$(powershell.exe 'Write-Host $env:UserName')

    WIN_AWS_PATH=$(find /mnt/c/Users -maxdepth 1 -type d -regextype posix-extended -iregex "/mnt/c/Users/${WIN_USER}")

    if [ -d "{$WIN_AWS_PATH}/.aws" ]; then
        PASS "AWS credentials already linked. Skipping..."
    else
        #RUN "Link AWS credentials" "ln -s '/mnt/c/Users/${USER}/.aws' '${HOME}/.aws'"
        echo "Linking AWS credentials..."
    fi
}

DELIM "Installing AWS CLI..."
PROMPT "Install AWS CLI" install_aws_cli
NEWLINE
PASS "Installed AWS CLI successfully."

DELIM "Linking AWS credentials..."
PROMPT "Link AWS credentials" link_win_credentials
NEWLINE
PASS "Linked AWS credentials successfully."
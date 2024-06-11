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
    PASS "Logged in Windows User detected: ${WIN_USER}"
    WIN_USER_PATH=$(find /mnt/c/Users -maxdepth 1 -type d -regextype posix-extended -iregex "/mnt/c/Users/${WIN_USER}")
    PASS "Windows User Path detected: ${WIN_USER_PATH}"

    if [[ -d "${WIN_USER_PATH}/.aws/" && ! -d "${HOME}/.aws" ]]; then
        PASS "Found AWS credentials in Windows."
        WARN "Symlinking AWS credentials..."
        RUN "Link AWS credentials" "ln -s '/mnt/c/Users/${WIN_USER}/.aws' '${HOME}/.aws'"
        echo "Linking AWS credentials..."
    fi
}

install_cdk() {
    ## Check if CDK is already installed
    if [ -f "/usr/local/bin/cdk" ]; then
        PASS "CDK is already installed. Skipping..."
    else 
        RUN "Install CDK" "mise exec -- npm install -g aws-cdk"
    fi
}


install_sam() {
    ## Check if SAM is already installed
    if [ -f "/usr/local/bin/sam" ]; then
        PASS "SAM is already installed. Skipping..."
    else 
        RUN "Download SAM" "curl -L 'https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip' -o 'aws-sam-cli-linux-x86_64.zip'"
        RUN "Unzip SAM" "unzip aws-sam-cli-linux-x86_64.zip -d sam-installation"
        RUN "Install SAM" "sudo ./sam-installation/install"
        RUN "Clean up" "rm -rf sam-installation aws-sam-cli-linux-x86_64.zip"
    fi

}


DELIM "Installing AWS CLI..."
PROMPT "Install AWS CLI" install_aws_cli
NEWLINE
PASS "Installed AWS CLI successfully."

DELIM "Installing AWS CDK..."
PROMPT "Install AWS CDK" install_cdk
NEWLINE
PASS "Installed AWS CDK successfully."

DELIM "Installing AWS SAM CLI..."
PROMPT "Install AWS SAM CLI" install_sam
NEWLINE
PASS "Installed AWS SAM CLI successfully."


DELIM "Linking AWS credentials..."
PROMPT "Link AWS credentials" link_win_credentials
NEWLINE
PASS "Linked AWS credentials successfully."
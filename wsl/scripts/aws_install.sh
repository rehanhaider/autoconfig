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

DELIM "Installing AWS CLI..."
PROMPT "Install AWS CLI" install_aws_cli
NEWLINE
PASS "Installed AWS CLI successfully."

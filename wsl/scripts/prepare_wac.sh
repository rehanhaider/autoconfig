#!/bin/bash


# DEFINITIONS

## Prepare the AUTOCONFIG directories
prepare_dir() {
    # Create the AUTOCONFIG_DIR 
    if [ -d "$AUTOCONFIG_DIR" ]; then
        INFO "AUTOCONFIG directory already exists"
    else
        WARN "Creating AUTOCONFIG directory..."
        RUN "AUTOCONFIG directory creation" "mkdir -p $AUTOCONFIG_DIR"
    fi

    # Create the AUTOCONFIG_BACKUPS_DIR
    if [ -d "$AUTOCONFIG_BACKUPS_DIR" ]; then
        INFO "AUTOCONFIG backups directory already exists"
    else
        WARN "Creating AUTOCONFIG backups directory..."
        RUN "AUTOCONFIG backups directory creation" "mkdir -p $AUTOCONFIG_BACKUPS_DIR"
    fi

    if [ -d "$AUTOCONFIG_THEMES_DIR" ]; then
        INFO "AUTOCONFIG themes directory already exists"
    else
        WARN "Creating AUTOCONFIG themes directory..."
        RUN "AUTOCONFIG themes directory creation" "mkdir -p $AUTOCONFIG_THEMES_DIR"
    fi

    # Array of directory names to be created
    directories=("config" "bash" "profile" "poshthemes")

    # Loop through each directory name in the array
    for dir in "${directories[@]}"; do
        # Check if the directory already exists
        if [ -d "$AUTOCONFIG_BACKUPS_DIR/$dir" ]; then
            INFO "AUTOCONFIG backups ${dir} directory already exists"
        else
            WARN "Creating AUTOCONFIG backups ${dir} directory..."
            RUN "AUTOCONFIG backups ${dir} directory creation" "mkdir -p $AUTOCONFIG_BACKUPS_DIR/$dir"
        fi
    done
}

## Backup existing AUTOCONFIG configuration
backup_config() {
    # This script copies the assets from WSL folder to the AUTOCONFIG_DIR
    # Backup exitig config folder
    if [ -d "$AUTOCONFIG_DIR/config" ]; then
        INFO "Backing up existing config folder ..."
        WARN "Only the  ${MAX_BACKUPS} latest config will be stored, older configs will be overwritten ..."
        RUN "Backup of existing config folder" "mv $AUTOCONFIG_DIR/config ${AUTOCONFIG_BACKUPS_DIR}/config/config_wac_$(date +%Y%m%d%H%M%S).bak"
    else
        INFO "No existing config folder found ..."
        INFO "Proceeding with installation ..."
    fi
}

## Copy the assets to the AUTOCONFIG_DIR
copy_config() {
    # Copy the assets to the AUTOCONFIG_DIR
    WARN "Copying assets to the autoconfig directory ..."
    RUN "Copying of assets" "cp -r $CUR_DIR/wsl/config $AUTOCONFIG_DIR"
}

# Main

## Imform the user that AUTOCONFIG directories are being created
DELIM "Creating AUTOCONFIG directories..."
PROMPT "creating AUTOCONFIG directories" prepare_dir
NEWLINE
PASS "AUTOCONFIG directories created successfully."

## Prompt the user to create backups of existing AUTOCONFIG configuration
DELIM "Creating backups of existing AUTOCONFIG configuration..."
PROMPT "creating backups of existing AUTOCONFIG configuration" backup_config
NEWLINE
PASS "AUTOCONFIG backup configured successfully."

## Prompt the user that new AUTOCONFIG assets are being copied to the AUTOCONFIG_DIR

DELIM "Copying new AUTOCONFIG configurations..."
PROMPT "copying new AUTOCONFIG configurations" copy_config
NEWLINE
PASS "AUTOCONFIG directories configured successfully."
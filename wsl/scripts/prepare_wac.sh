#!/bin/bash


# DEFINITIONS

## Prepare the AUTOCONFIG directories
prepare_dir() {
    # Create the AUTOCONFIG_DIR 
    if [ -d "$AUTOCONFIG_DIR" ]; then
        INFO "AUTOCONFIG directory already exists"
    else
        WARN "Creating AUTOCONFIG directory..."
        if err mkdir -p "$AUTOCONFIG_DIR"; then
            PASS "AUTOCONFIG directory created successfully."
        else
            FAIL "Failed to create AUTOCONFIG directory. Please ensure you have the necessary permissions. Exiting ..."
            exit 1
        fi
    fi

    # Create the AUTOCONFIG_BACKUPS_DIR
    if [ -d "$AUTOCONFIG_BACKUPS_DIR" ]; then
        INFO "AUTOCONFIG backups directory already exists"
    else
        WARN "Creating AUTOCONFIG backups directory..."
        if err mkdir -p "$AUTOCONFIG_BACKUPS_DIR"; then
            PASS "AUTOCONFIG backups directory created successfully."
        else
            FAIL "Failed to create AUTOCONFIG backups directory. Please ensure you have the necessary permissions. Exiting ..."
            exit 1
        fi
    fi

    if [ -d "$AUTOCONFIG_THEMES_DIR" ]; then
        INFO "AUTOCONFIG themes directory already exists"
    else
        WARN "Creating AUTOCONFIG themes directory..."
        if err mkdir -p "$AUTOCONFIG_THEMES_DIR"; then
            PASS "AUTOCONFIG themes directory created successfully."
        else
            FAIL "Failed to create AUTOCONFIG themes directory. Please ensure you have the necessary permissions. Exiting ..."
            exit 1
        fi
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
            if err mkdir -p "$AUTOCONFIG_BACKUPS_DIR/$dir"; then
                PASS "AUTOCONFIG backups ${dir} directory created successfully."
            else
                FAIL "Failed to create AUTOCONFIG backups ${dir} directory. Please ensure you have the necessary permissions. Exiting ..."
                exit 1
            fi
        fi
    done
}

## Backup existing AUTOCONFIG configuration
backup_config() {
    # This script copies the assets from WSL folder to the AUTOCONFIG_DIR
    # Backup exitig config folder
    if [ -d "$AUTOCONFIG_DIR/config" ]; then
        INFO "Backing up existing config folder ..."
        WARN "Only the latest config will be stored, older configs will be overwritten ..."
        if err mv "$AUTOCONFIG_DIR/config" "${AUTOCONFIG_BACKUPS_DIR}/config/config_wac_$(date +%Y%m%d%H%M%S).bak"; then
            PASS "Backups stored in ${AUTOCONFIG_BACKUPS_DIR}/config/config_wac_$(date +%Y%m%d%H%M%S).bak"
        else
            FAIL "Failed to backup existing config folder. Please ensure you have the necessary permissions. Exiting ..."
            exit 1
        fi
    else
        INFO "No existing config folder found ..."
        INFO "Proceeding with installation ..."
    fi
}

## Copy the assets to the AUTOCONFIG_DIR
copy_config() {
    # Copy the assets to the AUTOCONFIG_DIR
    WARN "Copying assets to the autoconfig directory ..."
    if err cp -r "$CUR_DIR/wsl/config" "$AUTOCONFIG_DIR"; then
        PASS "Assets copied successfully."
    else
        FAIL "Failed to copy assets to the autoconfig directory. Please ensure you have the necessary permissions. Exiting ..."
        exit 1
    fi
}

# Main

## Imform the user that AUTOCONFIG directories are being created
print_delimiter "Creating AUTOCONFIG directories..."
prompt_and_execute "creating AUTOCONFIG directories" prepare_dir
NEWLINE
PASS "AUTOCONFIG directories created successfully."

## Prompt the user to create backups of existing AUTOCONFIG configuration
print_delimiter "Creating backups of existing AUTOCONFIG configuration..."
prompt_and_execute "creating backups of existing AUTOCONFIG configuration" backup_config
NEWLINE
PASS "AUTOCONFIG backup configured successfully."

## Prompt the user that new AUTOCONFIG assets are being copied to the AUTOCONFIG_DIR

print_delimiter "Copying new AUTOCONFIG configurations..."
prompt_and_execute "copying new AUTOCONFIG configurations" copy_config
NEWLINE
PASS "AUTOCONFIG directories configured successfully."
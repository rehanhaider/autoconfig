#!/bin/bash

# Theme functions removed - preserving existing themes instead of overwriting

OMP_MIN_VERSION="27.2.0"
OMP_INSTALL_DIR="${HOME}/.local/bin"

omp_binary() {
    for omp_path in "${OMP_INSTALL_DIR}/oh-my-posh" "${HOME}/bin/oh-my-posh" "/usr/local/bin/oh-my-posh"; do
        if [ -x "${omp_path}" ]; then
            printf '%s\n' "${omp_path}"
            return 0
        fi
    done

    if command -v oh-my-posh >/dev/null 2>&1; then
        command -v oh-my-posh
        return 0
    fi

    return 1
}

omp_version() {
    local omp_path=$1

    "${omp_path}" version 2>/dev/null | awk '{print $1}'
}

omp_version_at_least() {
    local version=$1

    dpkg --compare-versions "${version}" ge "${OMP_MIN_VERSION}"
}

clear_omp_cache() {
    local omp_path

    if omp_path=$(omp_binary); then
        RUN "Clear Oh My Posh cache" "${omp_path} cache clear"
    else
        WARN "Oh My Posh binary not found. Skipping cache clear."
    fi
}

install_omp() {
    local omp_path
    local version

    if omp_path=$(omp_binary); then
        version=$(omp_version "${omp_path}")
        if [ -n "${version}" ] && omp_version_at_least "${version}"; then
            PASS "Oh My Posh ${version} is already installed at ${omp_path}. Skipping..."
            return 0
        fi

        WARN "Oh My Posh ${version:-unknown} is older than required ${OMP_MIN_VERSION}."
        WARN "Upgrading Oh My Posh..."
    else
        WARN "Oh My Posh binary does not exist..."
        WARN "Installing Oh My Posh..."
    fi

    RUN "Create local bin directory" "mkdir -p ${OMP_INSTALL_DIR}"
    RUN "Install or upgrade Oh My Posh" "curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ${OMP_INSTALL_DIR}"
}


configure_omp() {
 
    INFO "Configuring theme..."
    CHECK "Themes directory" "${AUTOCONFIG_DIR}/poshthemes"

    INFO "Checking if theme exists ..."
    local source_theme="${THEME_DIR}/$AUTOCONFIG_OMP_THEME_NAME"
    local target_theme="${AUTOCONFIG_DIR}/poshthemes/$AUTOCONFIG_OMP_THEME_NAME"

    if [ ! -f "${AUTOCONFIG_DIR}/poshthemes/$AUTOCONFIG_OMP_THEME_NAME" ]; then
        INFO "Installing Theme: $AUTOCONFIG_OMP_THEME_NAME ..."
        ## Copy the theme to the folder
        RUN "Copy theme folder" "cp ${source_theme} ${AUTOCONFIG_DIR}/poshthemes/"
        PASS "Theme $AUTOCONFIG_OMP_THEME_NAME installed successfully."
    elif cmp -s "${source_theme}" "${target_theme}"; then
        INFO "Found existing Theme: $AUTOCONFIG_OMP_THEME_NAME ..."
        PASS "Existing theme already matches AUTOCONFIG."
    else
        INFO "Found existing Theme: $AUTOCONFIG_OMP_THEME_NAME ..."
        WARN "Backing up and updating managed theme: $AUTOCONFIG_OMP_THEME_NAME"
        RUN "Theme backup" "cp ${target_theme} ${AUTOCONFIG_BACKUPS_DIR}/poshthemes/${AUTOCONFIG_OMP_THEME_NAME}_wac_$(date +%Y%m%d%H%M%S)"
        RUN "Copy theme folder" "cp ${source_theme} ${target_theme}"
        PASS "Theme $AUTOCONFIG_OMP_THEME_NAME updated successfully."
    fi
    clear_omp_cache
    ## Check if Profile backup directory exists
    CHECK "Oh My Posh configuration" "${AUTOCONFIG_BACKUPS_DIR}/profile"

    WARN "Backing up .profile"
    RUN "Profile backup" "cp ${HOME}/.profile ${AUTOCONFIG_BACKUPS_DIR}/profile/._wac_$(date +%Y%m%d%H%M%S)"
    
    WARN "Keeping the last ${MAX_BACKUPS} backups. Older backups will be deleted ..."
    RUN "Delete older backups" "find ${AUTOCONFIG_BACKUPS_DIR}/profile -name '._wac_*' -type f | sort -r | awk 'NR>${MAX_BACKUPS}' | xargs rm -f"

    ## Check if the the theme name exists in the .profile
    if grep -q "${AUTOCONFIG_START}" "${HOME}/.profile"; then
        WARN "Removing older AUTOCONFIG data"
        ## Remove lines that are between "# AUTOCONFIG" and "# END AUTOCONFIG"
        RUN "Remove previous AUTOCONFIG configuration" "sed -i '/# AUTOCONFIG/,/# END AUTOCONFIG/d' ${HOME}/.profile"
    fi
    ## Add the theme name to the .profile
    RUN "AUTOCONFIG start marker" "echo '${AUTOCONFIG_START}' >> ${HOME}/.profile"
    # shellcheck disable=SC2016
    RUN "Profile OMP config" "echo source '${AUTOCONFIG_DIR}/config/profile/omp_prompt' >> ${HOME}/.profile"
    RUN "AUTOCONFIG end marker" "echo '${AUTOCONFIG_END}' >> ${HOME}/.profile"
}

DELIM "Installing Oh My Posh..."
PROMPT "installation of Oh My Posh" install_omp
NEWLINE
PASS "Installed Oh My Posh successfully"


DELIM "Configuring Oh My Posh..."
PROMPT "configuration of Oh My Posh" configure_omp
NEWLINE
PASS "Configured Oh My Posh successfully."

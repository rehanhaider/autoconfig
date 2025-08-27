#!/bin/bash
shopt -s expand_aliases

# Set default values
# shellcheck disable=SC2034
MAX_BACKUPS=10 

## Set the directories
CUR_DIR=$(pwd)
SCRIPT_DIR="${CUR_DIR}/wsl/scripts"
LIB_DIR="${CUR_DIR}/wsl/lib"
# shellcheck disable=SC2034
THEME_DIR="${CUR_DIR}/themes"
# shellcheck disable=SC2034

THEMES=(
	"blue-owl"
	"gruvbox"
	"paradox"
	"quick-term"
	"autoconfig"
)

# shellcheck disable=SC2034
STEP=0

# shellcheck disable=SC1091
source "${CUR_DIR}/wsl/config/bash/exports"
# shellcheck disable=SC1091
source "${LIB_DIR}/ascii.sh"
# shellcheck disable=SC1091
source "${LIB_DIR}/directives.sh"
# shellcheck disable=SC1091
source "${LIB_DIR}/intro.sh"


# Display ASCII Art
NEWLINE
WARN "Running autoconfig script ..."
NEWLINE


rprint "${COLOR_WARN}" "${DELIMITER}"
NEWLINE
INFO -n "WSL Autoconfig in starting "

# Sleep for 5 seconds
# shellcheck disable=SC2034
for i in {1..4}; do
	rprint "${COLOR_INFO}" -n "."
	#sleep 0.25
done
NEWLINE
NEWLINE
rprint "${COLOR_WARN}" "${DELIMITER}"




# source "${SCRIPT_DIR}/install_packages.sh"
# source "${SCRIPT_DIR}/prepare_wac.sh"
# source "${SCRIPT_DIR}/install_mise.sh"
# source "${SCRIPT_DIR}/install_uv.sh"
# source "${SCRIPT_DIR}/bash_config.sh"
# source "${SCRIPT_DIR}/omp_config.sh"
# source "${SCRIPT_DIR}/git_config.sh"
# source "${SCRIPT_DIR}/aws_install.sh"
source "${SCRIPT_DIR}/docker_install.sh"

NEWLINE
rprint "${COLOR_WARN}" "${DELIMITER}"
PASS "WSL Autoconfig completed successfully."
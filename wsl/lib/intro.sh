#!/bin/bash

# Show the introduction

DISCLAIMER="This script is provided as is without any guarantees or warranty.\n\
You are free to use it at your own risk.\n\
I am not responsible for any damage or loss caused by this script."

rprint "${COLOR_WARN}" "${DELIMITER}"
rprint "${COLOR_PASS}" "Author: Rehan Haider"
rprint "${COLOR_PASS}" "GitHub: https://github.com/rehanhaider/wsl-autoconfig"
rprint "${COLOR_PASS}" "Version: 0.1"
rprint "${COLOR_WARN}" "${DELIMITER}"

# Reset the colour

rprint "${COLOR_WARN}" "${DELIMITER}"
rprint "${COLOR_FAIL}" "DISCLAIMER:"
rprint "${COLOR_INFO}" "$DISCLAIMER"
rprint "${COLOR_WARN}" "${DELIMITER}"
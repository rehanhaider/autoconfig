#!/bin/bash

# Show the introduction

DISCLAIMER="This script is provided as is without any guarantees or warranty.\n\
You are free to use it at your own risk.\n\
I am not responsible for any damage or loss caused by this script."

rprint "${WARNING}" "${DELIMITER}"
rprint "${SUCCESS}" "Author: Rehan Haider"
rprint "${SUCCESS}" "GitHub: https://github.com/rehanhaider/wsl-autoconfig"
rprint "${SUCCESS}" "Version: 0.1"
rprint "${WARNING}" "${DELIMITER}"

# Reset the colour
rprint "${WARNING}" "${DELIMITER}"
rprint "${ERROR}" "DISCLAIMER"
rprint "${INFO}" "$DISCLAIMER"
rprint "${WARNING}" "${DELIMITER}"
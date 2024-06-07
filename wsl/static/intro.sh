#!/bin/bash

# Show the introduction

DISCLAIMER="This script is provided as is without any guarantees or warranty.\n\
You are free to use it at your own risk.\n\
I am not responsible for any damage or loss caused by this script."

WARN "${DELIMITER}"
PASS "Author: Rehan Haider"
PASS "GitHub: https://github.com/rehanhaider/wsl-autoconfig"
PASS "Version: 0.1"
WARN "${DELIMITER}"

# Reset the colour
WARN "${DELIMITER}"
FAIL "DISCLAIMER"
INFO "$DISCLAIMER"
WARN "${DELIMITER}"
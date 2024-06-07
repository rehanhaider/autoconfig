#!/bin/bash

# Define the ASCII art

ascii_art="
 __          _______ _                      _         _____             __ _       
 \ \        / / ____| |          /\        | |       / ____|           / _(_)      
  \ \  /\  / / (___ | |         /  \  _   _| |_ ___ | |     ___  _ __ | |_ _  __ _ 
   \ \/  \/ / \___ \| |        / /\ \| | | | __/ _ \| |    / _ \|  _ \|  _| |/ _  |
    \  /\  /  ____) | |____   / ____ \ |_| | || (_) | |___| (_) | | | | | | | (_| |
     \/  \/  |_____/|______| /_/    \_\__,_|\__\___/ \_____\___/|_| |_|_| |_|\__, |
                                                                              __/ |
                                                                             |___/ 
"

# Define the color gradient (shades of cyan and blue)
colors=(
	'\033[38;5;61m'
	'\033[38;5;80m'
	'\033[38;5;33m'
	'\033[38;5;98m'
	'\033[38;5;87m'
	'\033[38;5;49m'
	'\033[38;5;88m'
    '\033[38;5;48m'
)

# Split the ASCII art into lines
IFS=$'\n' read -rd '' -a lines <<<"$ascii_art"

# Print each line with the corresponding color
for i in "${!lines[@]}"; do
	color_index=$((i % ${#colors[@]}))
	echo -e "${colors[color_index]}${lines[i]}"
	sleep 0.1
done

echo -e "\033[0m" # Reset the color
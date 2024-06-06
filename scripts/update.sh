#!/bin/bash

update_packages() {
    sudo apt update -y && sudo apt upgrade -y
}

if [ "$SILENT_MODE" = false ]; then
    # shellcheck disable=SC1091
    read -r -p "Update packages? [Y/N]  " yn
    case $yn in
        [Yy]* ) update_packages;;
        [Nn]* ) 
                echo -n "Skipping updating packages "
                # shellcheck disable=SC2034
                for i in {1..12}; do echo -n "." && sleep 0.25; done;;
        * ) echo "Please answer Y or N.";;
    esac
fi
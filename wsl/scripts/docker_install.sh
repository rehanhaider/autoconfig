#!/bin/bash


update_apt() {
        RUN "Install certificate" "sudo apt install ca-certificates"
        RUN "Install keyrings" "sudo install -m 0755 -d /etc/apt/keyrings"
        RUN "Install Docker GPG key" "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc"
        RUN "Install Docker GPG key" "sudo chmod a+r /etc/apt/keyrings/docker.asc"
        RUN "Add Docker repository" "echo deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo ${UBUNTU_CODENAME:-$VERSION_CODENAME}) stable | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null"
        RUN "Update Apt" "sudo apt update"
}

install_docker() {
    RUN "Install Docker" "sudo apt -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"
}



DELIM "Updating Apt with Docker repository..."
PROMPT "Update Apt" update_apt
NEWLINE
PASS "Apt updated successfully."

DELIM "Installing Docker..."
PROMPT "Install Docker" install_docker
NEWLINE
PASS "Docker installed successfully."




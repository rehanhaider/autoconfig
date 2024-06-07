# Automated Windows & WSL Configuration

This repository contains a script that automates the configuration of Windows and WSL. It installs the necessary software and tools for development and personal use.

This is an opinionated configuration, suitable for people who use WSL2 for development and Windows for personal use. This is in part inspired by [Omakub](https://omakub.org/), a script that configures Ubuntu OS.

I had Autoconfig for my own but thought others might find it useful as well.

## Usage

It has two components:

1. [WinConfig.ps1 - This script configures Windows.](#windows-configuration)
2. [wsl_config.sh - This script configures WSL.](#wsl-configuration)

## Windows Configuration

TBD

## WSL Configuration

Currently it configures the following:

1. **VSCode Terminal**: Configures the terminal prompt so that it shows the current directory and git branch. It also shows if the current directory is dirty. This will not be the primary terminal that you use by opening Windows Terminal, but available when you open VSCode. Useful because it shows the git branch and status without being too fancy.
2. **Oh My Posh**: Configures the terminal prompt with Oh My Posh. This will be the primary terminal that you use by opening Windows Terminal. This is fancy, shows current directory, git branch, status, and more. It is configured to use a customised `quick-term` theme and implemented using `.profile`.

```python
 __          _______ _                      _         _____             __ _
 \ \        / / ____| |          /\        | |       / ____|           / _(_)
  \ \  /\  / / (___ | |         /  \  _   _| |_ ___ | |     ___  _ __ | |_ _  __ _
   \ \/  \/ / \___ \| |        / /\ \| | | | __/ _ \| |    / _ \|  _ \|  _| |/ _  |
    \  /\  /  ____) | |____   / ____ \ |_| | || (_) | |___| (_) | | | | | | | (_| |
     \/  \/  |_____/|______| /_/    \_\__,_|\__\___/ \_____\___/|_| |_|_| |_|\__, |
                                                                              __/ |
                                                                             |___/
```

# Automated Windows & WSL Configuration

Autoconfig is an opinionated configuration of Dev Environment on Windows Subsystem for Linux 2 (WSL2). It if fully automated, customisable if needed, and reversible way of doing on WSL2.

Originally created for my personal use, I decided to share Autoconfig with others who may find it beneficial.

It draws inspiration from [Omakub](https://omakub.org/), a script that configures the Ubuntu OS.

![autoconfig automated configration of WSL2 development environment](./assets/autoconfig.gif)

## Features

## Supported Platforms

Tested on the following distributions:

1. Ubuntu 22.04 (Windows 11 + WSL2)
2. Ubuntu 24.04 (Windows 11 + WSL2)

It may work on other distributions, but it has not been tested.

## Usage

### Installing WSL

To use you can clone this repositorya and run `autoconfig.sh` from the root directory.

```bash
git clone https://github.com/rehanhaider/autoconfig.git
cd autoconfig
./autoconfig.sh
```

By default the script will run in silent mode.

### Interactive Mode

You can run the script in interactive mode by passing the `-i` flag.

```bash
./autoconfig.sh -i
```

You will need to install nerd fonts and configure them in your Microsoft Terminal settings. A font is included in the `font` directory.

## Features

Currently it configures the following:

# Automated Windows & WSL Configuration

This repository contains a script that automates the configuration of Windows and WSL. It installs the necessary software and tools for development and personal use.

## Features

1. **VSCode Terminal**: Configures the terminal prompt in VSCode to show the current directory and git branch, as well as indicating if the directory is dirty. This provides a simple and informative terminal experience within VSCode.

2. **Oh My Posh**: Configures the terminal prompt with Oh My Posh, which serves as the primary terminal when using Windows Terminal. Oh My Posh offers a more visually appealing prompt that displays the current directory, git branch, status, and more. It is configured to use a customized `quick-term` theme and implemented using `.profile`.

3. **Git**: Installs Git and prompts you to configure your name and email. It also configures the Windows Git credential manager to store credentials in the Windows Credential Manager. This is particularly useful if you use Git in both WSL and Windows.

4. **AWS CLI**: Installs the AWS CLI, symlinks the Windows `.aws` directory to WSL, and configures the CLI with the default profile. This allows you to use the same AWS CLI configuration in both WSL and Windows.

5. **Mise**: Installs Mise, a tool for managing dotfiles. It is configured to use the `mise` directory in the home directory, providing a convenient way to manage your dotfiles.

## Usage

To use this script, follow these steps:

1. Clone this repository:

   ```bash
   git clone https://github.com/rehanhaider/autoconfig.git
   cd autoconfig
   ```

2. Run the `autoconfig.sh` script from the root directory:

   ```bash
   ./autoconfig.sh
   ```

   By default, the script runs in silent mode.

### Interactive Mode

You can run the script in interactive mode by passing the `-i` flag:

```bash
./autoconfig.sh -i
```

In interactive mode, you will be prompted for additional configuration options.

## Additional Notes

Please note that Windows configuration is not currently supported, but may be added in future updates.

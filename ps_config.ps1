# This script prettifies the PowerShell using the Oh My Post PSReadLine module.

# Install Winget from the Microsoft Store
## Check if winget is installed
while (!(Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "Winget is not installed. Installing..."
    Start-Process "ms-windows-store://pdp/?productid=9NBLGGH4NNS1"
    Start-Sleep -Seconds 1
}
Write-Host "Winget is installed."

$winget_path = "$env:LOCALAPPDATA\Microsoft\WindowsApps"


## Check if winget is on the PATH
if ($env:Path -split ";" | Where-Object { $_ -eq $winget_path }) {
    Write-Host "Winget is on the PATH."
}
else {
    Write-Host "Winget is not on the PATH. Adding..."
    $env:Path += ";$winget_path"
    Write-Host "Winget added to the PATH."
}

# Install Windows Terminal from the Microsoft Store
## Check if Windows Terminal is installed
while (!(Get-AppxPackage -Name Microsoft.WindowsTerminal -ErrorAction SilentlyContinue)) {
    Write-Host "Windows Terminal is not installed. Installing..."
    Start-Process "ms-windows-store://pdp/?productid=9n0dx20hk701"
    Start-Sleep -Seconds 1
}
Write-Host "Windows Terminal is installed."


$font = "font/CaskaydiaCoveNerdFontMono-Regular.ttf"

## Install the font
if (Test-Path $font) {
    Write-Host "Found the font file."
    ## Check if the font exists in the Windows Fonts directory
    if (Test-Path "C:\Windows\Fonts\CaskaydiaCoveNerdFontMono-Regular.ttf") {
        Write-Host "Font already installed. Skipping..."
    }
    else {
        ## Copy the font to the Windows Fonts directory
        Copy-Item -Path $font -Destination "C:\Windows\Fonts\"
        Write-Host "Font installed successfully."
    }

}
else {
    Write-Host "Font file not found. Exiting..."
    exit
}

$omp_path = "$env:LOCALAPPDATA\Programs\oh-my-posh\bin"

## Install Oh My Posh
if (!(Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
    Write-Host "Oh My Posh is not installed. Installing..."
    winget install XP8K0HKJFRXGCK -h --accept-package-agreements
    Write-Host "Oh My Posh is installed."
    # Check if Oh My Posh is on the PATH
}
else {
    Write-Host "Oh My Posh is already installed."
}

if ($env:Path -split ";" | Where-Object { $_ -eq $omp_path }) {
    Write-Host "Oh My Posh is on the PATH."
}
else {
    Write-Host "Oh My Posh is not on the PATH. Adding..."
    $env:Path += ";$omp_path"
    Write-Host "Oh My Posh added to the PATH."
}

## Configure the PowerShell profile. Check if $PROFILE exists
if (!(Test-Path $PROFILE)) {
    Write-Host "Creating the PowerShell profile..."
    New-Item -Path $PROFILE -ItemType File -Force
    Write-Host "PowerShell profile created."
}
else {
    Write-Host "PowerShell profile already exists."
}

## Check if the following command is already in the profile "oh-my-posh init pwsh | Invoke-Expression"
if ((Get-Content $PROFILE) -contains "oh-my-posh init pwsh | Invoke-Expression") {
    Write-Host "Oh My Posh is already configured in the profile."
}
else {
    Write-Host "Configuring Oh My Posh in the profile..."
    Add-Content $PROFILE "oh-my-posh init pwsh | Invoke-Expression"
    Write-Host "Oh My Posh added in the profile."
}

## Configure theme

#Set-PoshPrompt -Theme paradox

# Check if PSReadLine is installed
if (!(Get-Module -Name PSReadLine -ListAvailable)) {
    Write-Host "PSReadLine is not installed. Installing..."
    Install-Module PsReadLine -Force
    Write-Host "PSReadLine is installed."
}
else {
    Write-Host "PSReadLine is already installed."
}
# Check if ($host.Name -eq 'ConsoleHost') command is already in the profile
if ((Get-Content $PROFILE) -contains "Import-Module PSReadLine") {
    Write-Host "PSReadLine is already configured in the profile."
}
else {
    Write-Host "Adding the PSReadline config statement in the profile..."
    Add-Content $PROFILE "`nif (`$host.Name -eq 'ConsoleHost')`n{`n`tImport-Module PSReadLine`n}`n"
    Write-Host "The PSReadline config added in the profile."
}


oh-my-posh init pwsh --config "themes/quick-term.omp.json" | Invoke-Expression


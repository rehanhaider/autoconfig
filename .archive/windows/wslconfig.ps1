# Check if WSL is installed

$wsl = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
if ($wsl.State -eq "Enabled") {
    Write-Host "WSL is installed."
    ## Ask is another instance of WSL Needs to be installed
    $answer = Read-Host "Do you want to install another instance of WSL? (y/n)"
    if ($answer -eq "y") {
        Write-Host "Installing WSL..."
        ## Provide the list of available Linux Distributions
        Write-Host "Available Linux Distributions:"
        wsl --list --online
    }
    else {
        Write-Host "Exiting..."
    }
}
else {
    # Check if 
    Write-Host "WSL is not installed"
}
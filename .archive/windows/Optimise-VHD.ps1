### This is a new comment

# set variable named DOCKER_WSL_DATA_PATH to the path where docker stores its data



wsl --shutdown

$Docker_WSL_DATA_PATH = "C:\Users\rehan\AppData\Local\Docker\wsl\data\ext4.vhdx"

# define a funtion
function GetDiskUsage {
    param ($Path_to_VHDX)
    # get the file size
    $size = (Get-Item $Path_to_VHDX).length / 1GB
    $size = [math]::Round($size, 0)

    # return the size
    return $size
}


if (Test-Path $Docker_WSL_DATA_PATH) {
    # get the file size
    $size = GetDiskUsage($Docker_WSL_DATA_PATH)
    Write-Output "Docker disk usage is: $size GB"
    Write-Output "Resize?"
    $resize = Read-Host
    if ($resize -eq "y") {
        Optimize-VHD -Path $Docker_WSL_DATA_PATH -Mode Full
        $size = GetDiskUsage($Docker_WSL_DATA_PATH)
        Write-Output "New disk usage is: $size GB"
    }
else {
    Write-Output "No Docker disk found"
}
}

Write-Output "=========================="

$Ubuntu_WSL_DATA_PATH = "C:\Users\rehan\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu_79rhkp1fndgsc\LocalState\ext4.vhdx"

if (Test-Path $Ubuntu_WSL_DATA_PATH) {
    # get the file size
    $size = GetDiskUsage($Ubuntu_WSL_DATA_PATH)
    Write-Output "WSL disk usage is: $size GB"
    Write-Output "Resize?"
    $resize = Read-Host
    if ($resize -eq "y") {
        Optimize-VHD -Path $Docker_WSL_DATA_PATH -Mode Full
        $size = GetDiskUsage($Ubuntu_WSL_DATA_PATH)
        Write-Output "New disk usage is: $size GB"
    }
else {
    Write-Output "No WSL disk found"
}
}
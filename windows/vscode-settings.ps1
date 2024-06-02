# Parameters
param (
    [string]$action
)

# Variables
$vsCodeSettingsPath = "$env:APPDATA\Code\User\settings.json"
$dotfilesRepoPath = "C:\Users\$Env:UserName\git\dotfiles"
$backupSettingsPath = "$dotfilesRepoPath\vscode\settings.json"
$commitMessage = "Update VSCode settings"

# Function to backup the VSCode settings to the dotfiles repo
function Backup-VSCodeSettings {
    # Check if the dotfiles repo directory exists
    if (-Not (Test-Path -Path $dotfilesRepoPath)) {
        Write-Host "Dotfiles repository path does not exist. Please check the path and try again."
        return
    }

    # Create the VSCode directory in the dotfiles repo if it does not exist
    if (-Not (Test-Path -Path "$dotfilesRepoPath\vscode")) {
        New-Item -ItemType Directory -Path "$dotfilesRepoPath\vscode" -Force
    }

    # Copy the VSCode settings file to the dotfiles repo
    Copy-Item -Path $vsCodeSettingsPath -Destination $backupSettingsPath -Force

    # Change to the dotfiles repo directory
    Set-Location -Path $dotfilesRepoPath

    # Git add, commit, and push changes
    git add vscode\settings.json
    if (git diff-index --quiet HEAD --) {
        Write-Host "No changes to commit."
    } else {
        git commit -m $commitMessage
        git push origin main  # Adjust the branch name if different
    }

    # Revert to the previous directory
    Set-Location -Path (Get-Location -Stack).Path

    Write-Host "VSCode settings backed up successfully."
}

# Function to restore the VSCode settings from the dotfiles repo
function Restore-VSCodeSettings {
    # Check if the backup settings file exists in the dotfiles repo
    if (-Not (Test-Path -Path $backupSettingsPath)) {
        Write-Host "Backup settings file does not exist. Please check the path and try again."
        return
    }

    # Copy the backup settings file to the VSCode settings path
    Copy-Item -Path $backupSettingsPath -Destination $vsCodeSettingsPath -Force

    Write-Host "VSCode settings restored successfully."
}

# Main script logic
if ($action -eq "backup") {
    Backup-VSCodeSettings
} elseif ($action -eq "restore") {
    Restore-VSCodeSettings
} else {
    Write-Host "Invalid action. Please use 'backup' or 'restore'."
}

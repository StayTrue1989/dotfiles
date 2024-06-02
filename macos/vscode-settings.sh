#!/bin/bash

# Variables
vsCodeSettingsPath="$HOME/Library/Application Support/Code/User/settings.json"
dotfilesRepoPath="$HOME/git/dotfiles"
backupSettingsPath="$dotfilesRepoPath/vscode/settings.json"
commitMessage="Update VSCode settings"
username="YourUserName" # Your GitHub username

# Function to backup the VSCode settings to the dotfiles repo
backup_vscode_settings() {
    # Check if the dotfiles repo directory exists
    if [ ! -d "$dotfilesRepoPath" ]; then
        echo "Dotfiles repository path does not exist. Please check the path and try again."
        return
    fi

    # Create the VSCode directory in the dotfiles repo if it does not exist
    mkdir -p "$dotfilesRepoPath/vscode"

    # Copy the VSCode settings file to the dotfiles repo
    cp "$vsCodeSettingsPath" "$backupSettingsPath"

    # Change to the dotfiles repo directory
    cd "$dotfilesRepoPath" || exit

    # Git add, commit, and push changes
    git add vscode/settings.json
    if git diff-index --quiet HEAD --; then
        echo "No changes to commit."
    else
        git commit -m "$commitMessage"
        echo "Enter your GitHub Personal Access Token:"
        read -s token
        git push https://$username:$token@github.com/$username/dotfiles.git main
    fi

    # Revert to the previous directory
    cd - || exit

    echo "VSCode settings backed up successfully."
}

# Function to restore the VSCode settings from the dotfiles repo
restore_vscode_settings() {
    # Check if the backup settings file exists in the dotfiles repo
    if [ ! -f "$backupSettingsPath" ]; then
        echo "Backup settings file does not exist. Please check the path and try again."
        return
    fi

    # Copy the backup settings file to the VSCode settings path
    cp "$backupSettingsPath" "$vsCodeSettingsPath"

    echo "VSCode settings restored successfully."
}

# Main script logic
case $1 in
    backup)
        backup_vscode_settings
        ;;
    restore)
        restore_vscode_settings
        ;;
    *)
        echo "Invalid action. Please use 'backup' or 'restore'."
        ;;
esac

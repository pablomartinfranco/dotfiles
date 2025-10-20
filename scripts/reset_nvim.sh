#!/bin/bash

# Function to backup and remove a directory
backup_and_remove() {
  local dir_path=$1
  if [ -d "$dir_path" ]; then
    local backup_path="${dir_path}.bak_$(date +%Y%m%d_%H%M%S)"
    echo "Backing up $dir_path to $backup_path"
    mv "$dir_path" "$backup_path"
    echo "Removed $dir_path"
  else
    echo "Directory $dir_path does not exist, skipping."
  fi
}

# Directories to reset
config_dir="$HOME/.config/nvim"
data_dir="$HOME/.local/share/nvim"
cache_dir="$HOME/.cache/nvim"

# Backup and remove the Neovim configuration directory
backup_and_remove "$config_dir"

# Backup and remove the Neovim data directory
backup_and_remove "$data_dir"

# Backup and remove the Neovim cache directory
backup_and_remove "$cache_dir"

echo "Neovim has been reset to factory settings."

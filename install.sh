#!/bin/bash

# Prosty skrypt instalacyjny dla dotfiles
# Uruchom: ./install.sh

DOTFILES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
CONFIG_DIR="$HOME/.config"

echo "Instalowanie konfiguracji..."

# Lista folderów do skopiowania
configs=("hypr" "waybar" "alacritty" "rofi" "fish")

for config in "${configs[@]}"; do
    if [ -d "$DOTFILES_DIR/.config/$config" ]; then
        echo "Kopiowanie $config -> $CONFIG_DIR/$config"
        mkdir -p "$CONFIG_DIR/$config"
        cp -r "$DOTFILES_DIR/.config/$config"/* "$CONFIG_DIR/$config/"
    fi
done

echo "Gotowe! Pamiętaj o zainstalowaniu odpowiednich pakietów na Debianie 13:"
echo "hyprland, waybar, alacritty, rofi, fish, blueman, fonts-inter, fonts-font-awesome"

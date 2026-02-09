#!/bin/bash

# Definicja plików konfiguracyjnych: "Etykieta;Ścieżka"
CONFIGS=(
    "Hyprland;/home/bogoos/.config/hypr/hyprland.conf"
    "Rofi;/home/bogoos/.config/rofi/config.rasi"
    "Waybar;/home/bogoos/.config/waybar/config.jsonc"
)

# Jeśli nie przekazano argumentu, wyświetl listę etykiet dla Rofi
if [ -z "$1" ]; then
    for item in "${CONFIGS[@]}"; do
        echo "${item%%;*}"
    done
else
    # Jeśli wybrano element, znajdź ścieżkę i otwórz w terminalu z vim
    CHOICE="$1"
    for item in "${CONFIGS[@]}"; do
        LABEL="${item%%;*}"
        PATH_TO_FILE="${item#*;}"
        
        if [ "$LABEL" == "$CHOICE" ]; then
            FULL_PATH=$(eval echo "$PATH_TO_FILE")
            # Uruchom ghostty z vimem w tle i wyjdź natychmiast, aby Rofi mogło się zamknąć
            /snap/ghostty/current/bin/ghostty -e vim "$FULL_PATH" &
            exit 0
        fi
    done
fi

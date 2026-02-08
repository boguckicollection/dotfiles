#!/bin/bash
WALLPAPER_DIR="/home/bogoos/Obrazy/tapety/tapety/daily"
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.webp" \) | shuf -n 1)

if [ -n "$WALLPAPER" ]; then
    pkill swaybg
    swaybg -i "$WALLPAPER" -m fill &
fi

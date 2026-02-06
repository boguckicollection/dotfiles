#!/usr/bin/env bash

shutdown="  Shutdown"
reboot="󰜉  Reboot"
suspend="󰤄  Suspend"
logout="󰍃  Logout"

selected=$(echo -e "$shutdown\n$reboot\n$suspend\n$logout" | rofi -dmenu -i -p "Power Menu")

case $selected in
    "$shutdown")
        systemctl poweroff ;;
    "$reboot")
        systemctl reboot ;;
    "$suspend")
        systemctl suspend ;;
    "$logout")
        hyprctl dispatch exit ;;
esac

#!/usr/bin/env bash

networks=$(nmcli -t -f SSID dev wifi list | grep -v '^--' | sort -u)
selected_network=$(echo "$networks" | rofi -dmenu -i -p "Wi-Fi")

if [ -n "$selected_network" ]; then
    password=$(rofi -dmenu -p "Password for $selected_network" -password)
    if [ -n "$password" ]; then
        nmcli dev wifi connect "$selected_network" password "$password"
    fi
fi

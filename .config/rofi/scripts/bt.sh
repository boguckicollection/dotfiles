#!/usr/bin/env bash

devices=$(bluetoothctl devices | cut -d ' ' -f 3-)
selected_device=$(echo "$devices" | rofi -dmenu -i -p "Bluetooth")

if [ -n "$selected_device" ]; then
    mac=$(bluetoothctl devices | grep "$selected_device" | cut -d ' ' -f 2)
    bluetoothctl connect "$mac"
fi

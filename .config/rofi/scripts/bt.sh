#!/usr/bin/env bash

BOSE_MAC="C8:7B:23:0D:B7:0E"
BOSE_NAME="Bose QC45"

is_connected() {
    bluetoothctl info "$BOSE_MAC" 2>/dev/null | grep -q "Connected: yes"
}

is_powered() {
    bluetoothctl show 2>/dev/null | grep -q "Powered: yes"
}

build_menu() {
    local options=""
    
    if is_powered; then
        options+="󰂯  Bluetooth: ON\n"
    else
        options+="󰂲  Bluetooth: OFF\n"
        echo -e "$options"
        return
    fi
    
    options+="─────────────\n"
    
    if is_connected; then
        options+="  $BOSE_NAME (połączono)\n"
        options+="󰂲  Rozłącz $BOSE_NAME"
    else
        options+="󰂯  Połącz $BOSE_NAME"
    fi
    
    echo -e "$options"
}

handle_selection() {
    case "$1" in
        *"Bluetooth: ON"*)
            bluetoothctl power off
            notify-send "Bluetooth" "Wyłączony"
            ;;
        *"Bluetooth: OFF"*)
            bluetoothctl power on
            notify-send "Bluetooth" "Włączony"
            ;;
        *"Połącz"*)
            notify-send "Bluetooth" "Łączenie z $BOSE_NAME..."
            bluetoothctl trust "$BOSE_MAC" &>/dev/null
            bluetoothctl connect "$BOSE_MAC" &>/dev/null && \
                notify-send "Bluetooth" "Połączono z $BOSE_NAME" || \
                notify-send "Bluetooth" "Błąd łączenia"
            ;;
        *"Rozłącz"*)
            bluetoothctl disconnect "$BOSE_MAC" &>/dev/null && \
                notify-send "Bluetooth" "Rozłączono $BOSE_NAME" || \
                notify-send "Bluetooth" "Błąd rozłączania"
            ;;
        *"─────"*|"")
            exit 0
            ;;
    esac
}

selected=$(build_menu | rofi -dmenu -i -p "󰂯 Bluetooth" -no-custom)
handle_selection "$selected"

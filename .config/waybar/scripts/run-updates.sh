#!/bin/bash
# Uruchom terminal z aktualizacjami

update_cmd="echo 'Aktualizowanie APT...' && sudo apt update && sudo apt upgrade -y; "
update_cmd+="echo ''; echo 'Aktualizowanie Flatpak...' && flatpak update -y; "
update_cmd+="echo ''; echo 'Aktualizowanie Snap...' && sudo snap refresh; "
update_cmd+="echo ''; echo 'Aktualizacja zakończona. Zamykam za 3s...'; sleep 3"

alacritty --class floating-update -T "System Updates" -e bash -c "$update_cmd"

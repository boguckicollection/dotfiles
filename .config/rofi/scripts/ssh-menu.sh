#!/bin/bash
LOG_FILE="/tmp/ssh-menu.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "Start SSH Menu"
declare -A SERVERS
SERVERS=(
    ["Home Server"]="192.168.0.197|bogus|pirwefij"
)

# Generuj listę dla Rofi
options=""
# Pobierz klucze (nazwy serwerów)
keys=("${!SERVERS[@]}")
# Iteruj po kluczach
for key in "${keys[@]}"; do
    options+="$key\n"
done

# Wyświetl menu Rofi
selected=$(echo -e "$options" | rofi -dmenu -i -p "SSH Connect" -theme ~/.config/rofi/config.rasi)

echo "Selected: $selected"

if [ -n "$selected" ]; then
    # Pobierz dane wybranego serwera
    # Bash 4.x associative arrays są tricky z kolejnością, więc szukamy po kluczu
    data="${SERVERS[$selected]}"
    
    if [ -n "$data" ]; then
        IFS='|' read -r ip user pass <<< "$data"
        echo "Connecting to $user@$ip..."
        
        # Ustaw tytuł okna
        title="SSH: $user@$ip ($selected)"
        
        # Komenda: ustaw tytuł -> clear -> ssh (quiet) -> jeśli błąd to czekaj
        cmd="printf '\033]0;%s\007' '$title'; clear; sshpass -p '$pass' ssh -q -o StrictHostKeyChecking=no $user@$ip || read -p 'Connection failed...'"
        
        # Uruchom Ghostty z klasą ssh-term i tytułem
        ghostty --class=ssh-term --title="$title" -e bash -c "$cmd" &
    else
        echo "Error: Server not found in config"
    fi
else
    echo "No selection made"
fi

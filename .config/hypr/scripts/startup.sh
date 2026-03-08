#!/bin/bash

# --- Hyprland Smart Startup ---
# Uruchamia aplikacje i inteligentnie czeka na ich okna, by przenieść je "po cichu".
# Nie blokuje pulpitu, nie wymaga focusu.

LOG="/tmp/hypr_smart_start.log"
exec > "$LOG" 2>&1
echo "--- Start: $(date) ---"

# Funkcja: Uruchom, Czekaj, Przenieś (w tle)
# Użycie: smart_launch "komenda" "regex_klasy" "workspace_id" "resize_params (opcjonalne)"
smart_launch() {
    CMD=$1
    CLASS_REGEX=$2
    WS=$3
    RESIZE=$4

    echo "[$CLASS_REGEX] Uruchamiam: $CMD"
    $CMD &
    PID=$!

    # Uruchamiamy subshell w tle, żeby nie blokować reszty skryptu
    (
        # Czekamy max 60 sekund na pojawienie się okna (zwiększono dla Electrona)
        for i in {1..120}; do
            # Szukamy adresu okna pasującego do klasy za pomocą jq (case-insensitive grep)
            # Używamy regexa (?i) dla pewności
            ADDR=$(hyprctl clients -j | jq -r ".[] | select(.class | test(\"(?i)$CLASS_REGEX\")) | .address" | head -n1)

            if [ ! -z "$ADDR" ] && [ "$ADDR" != "null" ]; then
                echo "[$CLASS_REGEX] Znaleziono okno: $ADDR. Przenoszę na $WS..."
                
                # Ciche przeniesienie konkretnego adresu na workspace
                hyprctl dispatch movetoworkspacesilent "$WS,address:$ADDR"
                
                # Dla pewności czekamy jeszcze chwilę i sprawdzamy czy nie otworzyło się drugie okno (typowe dla Electrona)
                sleep 2
                ADDR2=$(hyprctl clients -j | jq -r ".[] | select(.class | test(\"(?i)$CLASS_REGEX\")) | .address" | head -n1)
                if [ "$ADDR2" != "$ADDR" ] && [ ! -z "$ADDR2" ]; then
                     hyprctl dispatch movetoworkspacesilent "$WS,address:$ADDR2"
                fi

                exit 0
            fi
            sleep 0.5
        done
        echo "[$CLASS_REGEX] Timeout! Okno się nie pojawiło."
    ) &
}

# --- 1. Terminal (Alacritty) -> WS 1 ---
if command -v alacritty &> /dev/null; then
    ALACRITTY="alacritty"
else
    ALACRITTY="alacritty"
fi
smart_launch "$ALACRITTY" "Alacritty" 1

# --- 2. Firefox -> WS 2 ---
smart_launch "firefox" "firefox" 2

# --- 3. Signal & Todoist -> WS 3 ---
smart_launch "flatpak run org.signal.Signal" "Signal" 3
smart_launch "/snap/bin/todoist" "Todoist" 3

# --- 4. Spotify & Vesktop -> WS 4 ---
smart_launch "/snap/bin/spotify" "Spotify" 4
smart_launch "flatpak run dev.vencord.Vesktop" "vesktop" 4

# --- 5. Antigravity -> WS 5 ---
smart_launch "antigravity" "antigravity" 5

# --- 6. Chill -> WS 6 ---
smart_launch "flatpak run com.rafaelmardojai.Blanket" "Blanket" 6
smart_launch "flatpak run org.gabmus.gfeeds" "gfeeds" 6

echo "--- Zlecono wszystkie zadania. Tło pracuje. ---"

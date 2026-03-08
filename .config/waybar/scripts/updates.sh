#!/bin/bash

# Sprawdzanie APT (z ominięciem ostrzeżeń interfejsu CLI i polskich znaków)
apt_updates=$(env LANG=C apt-get -s upgrade 2>/dev/null | grep -P '^\d+ upgraded' | cut -d" " -f1)
[ -z "$apt_updates" ] && apt_updates="0"

# Sprawdzanie Flatpak
flatpak_updates=$(flatpak remote-ls --updates 2>/dev/null | wc -l)
[ -z "$flatpak_updates" ] && flatpak_updates="0"

# Sprawdzanie Snap
# snap refresh --list zwraca info o błędzie lub "All snaps up to date." gdy nie ma nic.
# wc -l policzy ewentualne wiersze tabeli z nowymi wersjami
snap_updates=0
if snap refresh --list 2>/dev/null | grep -q "Name"; then
    snap_updates=$(snap refresh --list 2>/dev/null | grep -v "^Name" | wc -l)
fi

# Sumowanie wszystkich aktualizacji
total_updates=$((apt_updates + flatpak_updates + snap_updates))

if [ "$total_updates" -gt 0 ]; then
    tooltip="Dostępne aktualizacje:\nAPT: $apt_updates\nFlatpak: $flatpak_updates\nSnap: $snap_updates"
    printf '{"text": "\uf019 %s", "tooltip": "%s", "class": "updates-available"}\n' "$total_updates" "$tooltip"
else
    printf '{"text": "\uf019 0", "tooltip": "System w pełni aktualny", "class": "updates-none"}\n'
fi

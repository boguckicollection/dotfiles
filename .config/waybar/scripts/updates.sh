#!/bin/bash
updates=$(apt list --upgradable 2>/dev/null | grep -c upgradable 2>/dev/null || echo "0")
updates=$(echo "$updates" | tr -d '\n' | grep -o '[0-9]*' || echo "0")
[ -z "$updates" ] && updates=0

if [ "$updates" -gt 0 ] 2>/dev/null; then
    printf '{"text": "\uf019 %s", "tooltip": "%s aktualizacji dostępnych", "class": "updates-available"}' "$updates" "$updates"
else
    printf '{"text": "\uf019 0", "tooltip": "System aktualny", "class": "updates-none"}'
fi

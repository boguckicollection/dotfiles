#!/bin/bash
# System monitor for alerts

TEMP=$(cat /sys/class/thermal/thermal_zone2/temp 2>/dev/null || echo 0)
TEMP=$((TEMP / 1000))

# Get CPU usage without hanging
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/")
CPU=$(awk "BEGIN {print int(100 - $CPU_IDLE)}")

# Read previous state to avoid spamming notifications
STATE_FILE="/tmp/sys_monitor_state"
if [ -f "$STATE_FILE" ]; then
    source "$STATE_FILE"
else
    LAST_TEMP_ALERT=0
    LAST_CPU_ALERT=0
fi

NOW=$(date +%s)

# Alert if Temp > 85 and it's been at least 60 seconds since last alert
if [ "$TEMP" -gt 85 ]; then
    if [ $((NOW - LAST_TEMP_ALERT)) -gt 60 ]; then
        notify-send -u critical "🔥 Krytyczna Temperatura" "Uważaj! CPU osiągnął ${TEMP}°C!" -i dialog-warning
        LAST_TEMP_ALERT=$NOW
    fi
fi

# Alert if CPU > 95 and it's been at least 60 seconds since last alert
if [ "$CPU" -gt 95 ]; then
    if [ $((NOW - LAST_CPU_ALERT)) -gt 60 ]; then
        notify-send -u critical "⚠️ Przeciążenie Systemu" "Zużycie procesora: ${CPU}%" -i dialog-warning
        LAST_CPU_ALERT=$NOW
    fi
fi

echo "LAST_TEMP_ALERT=$LAST_TEMP_ALERT" > "$STATE_FILE"
echo "LAST_CPU_ALERT=$LAST_CPU_ALERT" >> "$STATE_FILE"

# Return empty JSON so Waybar module is invisible but runs the script
echo "{}"

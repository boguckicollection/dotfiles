#!/bin/bash

# Twoje portfolio
BTC_AMOUNT=0.020464
ETH_AMOUNT=0.268458
XRP_AMOUNT=310.24023

# Pobierz aktualne ceny (timeout 10s aby nie zawieszać waybar)
data=$(curl -s --max-time 10 "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,ripple&vs_currencies=pln&include_24hr_change=true")

if [ -z "$data" ] || [ "$data" = "null" ] || ! echo "$data" | jq -e '.bitcoin.pln' >/dev/null 2>&1; then
    echo '{"text": "󰠓 --", "tooltip": "Brak połączenia", "class": "portfolio-error"}'
    exit 0
fi

btc_pln=$(echo "$data" | jq -r '.bitcoin.pln // 0')
eth_pln=$(echo "$data" | jq -r '.ethereum.pln // 0')
xrp_pln=$(echo "$data" | jq -r '.ripple.pln // 0')

btc_change=$(echo "$data" | jq -r '.bitcoin.pln_24h_change // 0')
eth_change=$(echo "$data" | jq -r '.ethereum.pln_24h_change // 0')
xrp_change=$(echo "$data" | jq -r '.ripple.pln_24h_change // 0')

# Walidacja - upewnij się że wartości są liczbami, nie śmieciami
for val in "$btc_pln" "$eth_pln" "$xrp_pln" "$btc_change" "$eth_change" "$xrp_change"; do
    if ! echo "$val" | grep -qE '^-?[0-9]+\.?[0-9]*([eE][+-]?[0-9]+)?$'; then
        echo '{"text": "󰠓 --", "tooltip": "Błąd danych API", "class": "portfolio-error"}'
        exit 0
    fi
done

# Oblicz wartości (2>/dev/null + fallback na wypadek błędu bc)
btc_value=$(echo "scale=2; $BTC_AMOUNT * $btc_pln" | bc 2>/dev/null) || btc_value=0
eth_value=$(echo "scale=2; $ETH_AMOUNT * $eth_pln" | bc 2>/dev/null) || eth_value=0
xrp_value=$(echo "scale=2; $XRP_AMOUNT * $xrp_pln" | bc 2>/dev/null) || xrp_value=0

total=$(echo "scale=2; ${btc_value:-0} + ${eth_value:-0} + ${xrp_value:-0}" | bc 2>/dev/null) || total=0
total_k=$(echo "scale=2; ${total:-0} / 1000" | bc 2>/dev/null) || total_k=0

# Oblicz średnią zmianę ważoną wartością
if [ -n "$total" ] && [ "$(echo "${total:-0} > 0" | bc 2>/dev/null)" = "1" ]; then
    weighted_change=$(echo "scale=2; ($btc_value * $btc_change + $eth_value * $eth_change + $xrp_value * $xrp_change) / $total" | bc 2>/dev/null) || weighted_change=0
else
    weighted_change=0
fi

# Strzałka trendu i klasa
if [ "$(echo "${weighted_change:-0} > 0.5" | bc 2>/dev/null)" = "1" ]; then
    arrow="↑"
    class="portfolio-up"
elif [ "$(echo "${weighted_change:-0} < -0.5" | bc 2>/dev/null)" = "1" ]; then
    arrow="↓"
    class="portfolio-down"
else
    arrow="→"
    class="portfolio-stable"
fi

# Tooltip
tooltip="Portfolio Crypto\\n\\nBTC: ${BTC_AMOUNT} = ${btc_value} PLN (${btc_change}%)\\nETH: ${ETH_AMOUNT} = ${eth_value} PLN (${eth_change}%)\\nXRP: ${XRP_AMOUNT} = ${xrp_value} PLN (${xrp_change}%)\\n\\nRazem: ${total} PLN\\nZmiana 24h: ${weighted_change}%"

# Ikona oddzielnie w <span> ze stałym kolorem
printf '{"text": "<span color=\\"#c0c0c0\\">󰠓</span> %sk %s", "tooltip": "%s", "class": "%s"}' "$total_k" "$arrow" "$tooltip" "$class"

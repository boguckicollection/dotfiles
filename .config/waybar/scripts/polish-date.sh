#!/bin/bash
days=("Nie" "Pon" "Wt" "Śr" "Czw" "Pt" "Sob")
months=("sty" "lut" "mar" "kwi" "maj" "cze" "lip" "sie" "wrz" "paź" "lis" "gru")

day_num=$(date +%w)
day_of_month=$(date +%d)
month_num=$((10#$(date +%m) - 1))
time=$(date +%H:%M)

echo "${days[$day_num]} $day_of_month ${months[$month_num]}  $time"

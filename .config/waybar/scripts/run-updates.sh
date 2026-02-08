#!/bin/bash
# Uruchom terminal z aktualizacjami
ghostty --class=floating-update -e bash -c "sudo apt update && sudo apt upgrade -y; echo ''; echo 'Aktualizacja zakończona. Zamykam za 3s...'; sleep 3"

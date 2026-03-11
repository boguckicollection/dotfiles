#!/bin/bash

# === Hyprland & Full System Backup Installer ===
# Autor: Bogoos
# Wersja: 3.0 (Full System Clone)
# 
# Instaluje pełne środowisko:
# - Pakiety systemowe
# - Konfiguracje .config
# - Tapety
# - Pliki shell (.bashrc, .profile, .gitconfig)
# - Ustawienia dconf
# - Skrypty użytkownika
#
# NIE instaluje (bezpieczeństwo):
# - Klucze SSH
# - Hasła / sekrety
# - Pliki .bash_history
# - Dane przeglądarek

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "=============================================="
echo "  🚀 Hyprland Full System Installer v3.0"
echo "=============================================="

# === KOLORY ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# === 1. INSTALACJA PAKIETÓW ===
echo ""
echo "=== 📦 Instalacja pakietów systemowych ==="

# Dodanie PPA Hyprland (Ubuntu 24.04)
log_info "Dodawanie PPA Hyprland..."
sudo add-apt-repository -y ppa:hyprland/stable || true
sudo apt update

log_info "Aktualizacja systemu..."
sudo apt update && sudo apt upgrade -y

# Podstawowe narzędzia
log_info "Instalacja podstawowych narzędzi..."
sudo apt install -y git curl wget build-essential unzip tar fastfetch htop jq bc

# Hyprland i środowisko graficzne
log_info "Instalacja Hyprland i narzędzi Wayland..."
sudo apt install -y hyprland waybar rofi wofi sway-notification-center swaybg swaylock swayidle hyprpaper \
    polkit-kde-agent-1 xdg-desktop-portal-hyprland \
    brightnessctl playerctl pamixer pavucontrol

# Bluetooth i powiadomienia (dla skryptów Rofi)
log_info "Instalacja Bluetooth i powiadomień..."
sudo apt install -y bluez bluez-tools libnotify-bin

# Clipboard (cliphist)
log_info "Instalacja cliphist..."
sudo apt install -y cliphist 2>/dev/null || log_warn "cliphist niedostępne - zainstaluj ręcznie"

# Dodatki Hyprland
log_info "Instalacja dodatków Hyprland..."
sudo apt install -y hypridle hyprlock 2>/dev/null || log_warn "hypridle/hyprlock niedostępne"

# Powiadomienia
log_info "Konfiguracja powiadomień..."

# Stylizacja Qt
sudo apt install -y qt5ct || true
sudo apt install -y qt5-style-kvantum 2>/dev/null || log_warn "qt5-style-kvantum niedostępne"

# Terminal i Shell
log_info "Instalacja terminala i powłoki..."
sudo apt install -y fish alacritty

# Czcionki
log_info "Instalacja czcionek..."
sudo apt install -y fonts-font-awesome fonts-jetbrains-mono fonts-noto-color-emoji fonts-powerline

# Nerd Fonts
log_info "Instalacja Nerd Fonts..."
mkdir -p ~/.local/share/fonts
cd /tmp
if [ ! -d "$HOME/.local/share/fonts/JetBrainsMono" ]; then
    curl -fLo "JetBrainsMono.zip" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip
    unzip -o JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMono
    rm JetBrainsMono.zip
    fc-cache -f -v
fi

# SDDM
log_info "Instalacja SDDM..."
sudo apt install -y sddm qml-module-qtquick-controls2 qml-module-qtquick-layouts qml-module-qtgraphicaleffects

# Dconf (do przywracania ustawień)
sudo apt install -y dconf-cli || true

# === 2. KONFIGURACJA SDDM ===
echo ""
echo "=== 🖥️ Konfiguracja SDDM ==="

log_info "Instalacja motywu SDDM Sugar Candy..."
if [ ! -d "/usr/share/sddm/themes/sugar-candy" ]; then
    sudo mkdir -p /usr/share/sddm/themes/sugar-candy
    git clone https://github.com/Kangie/sddm-sugar-candy.git /tmp/sugar-candy
    sudo cp -r /tmp/sugar-candy/* /usr/share/sddm/themes/sugar-candy/
fi

# Kopiowanie tapety i konfiguracji do SDDM
if [ -f "./wallpapers/mecha.jpg" ]; then
    log_info "Ustawianie tapety SDDM..."
    sudo mkdir -p /usr/share/sddm/themes/sugar-candy/Backgrounds
    sudo cp "./wallpapers/mecha.jpg" /usr/share/sddm/themes/sugar-candy/Backgrounds/mecha.jpg 2>/dev/null || true
fi

if [ -f "./sddm/theme.conf" ]; then
    log_info "Kopiowanie konfiguracji motywu SDDM..."
    sudo cp ./sddm/theme.conf /usr/share/sddm/themes/sugar-candy/theme.conf 2>/dev/null || true
fi

# Aktywacja motywu
echo "[Theme]
Current=sugar-candy" | sudo tee /etc/sddm.conf

# === 3. KOPIOWANIE KONFIGURACJI ===
echo ""
echo "=== 📂 Kopiowanie konfiguracji ==="

# Tworzenie katalogów
mkdir -p ~/.config
mkdir -p ~/.local/bin
mkdir -p ~/Obrazy/tapety

# Kopiuje wszystkie konfiguracje z .config/
log_info "Kopiowanie .config/..."
if [ -d "./.config" ]; then
    cp -r ./.config/* ~/.config/
    
    # Ustawianie uprawnień do skryptów
    chmod +x ~/.config/hypr/scripts/*.sh 2>/dev/null || true
    chmod +x ~/.config/waybar/scripts/*.sh 2>/dev/null || true
    chmod +x ~/.config/rofi/scripts/*.sh 2>/dev/null || true
    chmod +x ~/.config/hypr/scripts/*.sh 2>/dev/null || true
fi

# Kopiuje skrypty użytkownika
log_info "Kopiowanie skryptów użytkownika..."
if [ -d "./scripts" ]; then
    cp -r ./scripts/* ~/.local/bin/
    chmod +x ~/.local/bin/*
fi

# Kopiuje tapety
log_info "Kopiowanie tapet..."
if [ -d "./wallpapers" ]; then
    cp -r ./wallpapers/* ~/Obrazy/tapety/
fi

# Kopiuje pliki shell
log_info "Kopiowanie plików konfiguracyjnych powłoki..."
[ -f "./.bashrc" ] && cp ./.bashrc ~/
[ -f "./.profile" ] && cp ./.profile ~/
[ -f "./.gitconfig" ] && cp ./.gitconfig ~/

# === 4. PRZYWRACANIE USTAWIEŃ DCONF ===
echo ""
echo "=== ⚙️ Przywracanie ustawień dconf ==="

if [ -f "./dconf-backup.ini" ]; then
    log_info "Przywracanie ustawień systemowych..."
    dconf load / < ./dconf-backup.ini
else
    log_warn "Brak pliku dconf-backup.ini - pomijanie"
fi

# === 5. ZMIANA POWŁOKI ===
echo ""
echo "=== 🐟 Konfiguracja powłoki ==="

if [ "$SHELL" != "/usr/bin/fish" ]; then
    log_info "Zmiana domyślnej powłoki na Fish..."
    chsh -s /usr/bin/fish
fi

# === 6. USTAWIENIA GTK ===
echo ""
echo "=== 🌑 Ustawienia GTK i wyglądu ==="

gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark' 2>/dev/null || true
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true

# === 7. FINALNE KROKI ===
echo ""
echo "=== ✅ Instalacja zakończona ==="

log_info "Struktura katalogów:"
echo "  ~/.config/     - Konfiguracje aplikacji"
echo "  ~/.local/bin/  - Skrypty użytkownika"  
echo "  ~/Obrazy/tapety/ - Tapety"
echo "  ~/.bashrc      - Konfiguracja bash"
echo "  ~/.profile     - Profil systemu"
echo ""
log_info "Uruchom ponownie komputer i zaloguj się do Hyprland"
echo ""
log_warn "Pamiętaj o skonfigurowaniu SSH na nowym komputerze:"
echo "  - Wygeneruj nowe klucze SSH"
echo "  - Skopiuj pliki z ~/.ssh/ (jeśli potrzebne)"
echo "  - Skonfiguruj secrets dla aplikacji"

echo ""
echo "=============================================="
echo "  🎉 Gotowe!"
echo "=============================================="

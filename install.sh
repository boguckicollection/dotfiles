#!/bin/bash

# --- Hyprland & Dotfiles Installer for Ubuntu/Debian ---
# Autor: Bogoos & Sisyphus
# Wersja: 2.0 (Full Auto)

set -e # Przerwij w razie błędu

echo "🚀 Rozpoczynam instalację środowiska Hyprland..."

# 1. Aktualizacja systemu i instalacja zależności
echo "📦 Aktualizacja repozytoriów..."
sudo apt update && sudo apt upgrade -y

echo "📦 Instalacja wymaganych pakietów..."
# Podstawowe narzędzia
sudo apt install -y git curl wget build-essential unzip tar neofetch htop

# Hyprland i środowisko graficzne
# (Ubuntu 24.04 ma hyprland w repo, dla starszych trzeba dodać ppa)
sudo apt install -y hyprland waybar rofi wofi swaync swaybg swaylock swayidle \
    polkit-kde-agent-1 xdg-desktop-portal-hyprland qt5-style-kvantum qt5ct \
    brightnessctl playerctl pamixer pavucontrol

# Terminal i Shell
sudo apt install -y fish alacritty

# Czcionki
sudo apt install -y fonts-font-awesome fonts-jetbrains-mono fonts-noto-color-emoji

# SDDM (Display Manager)
echo "🖥️ Instalacja i konfiguracja SDDM..."
sudo apt install -y sddm qml-module-qtquick-controls2 qml-module-qtquick-layouts qml-module-qtgraphicaleffects

# 2. Konfiguracja SDDM (Motyw Sugar Candy)
echo "🍬 Instalacja motywu SDDM Sugar Candy..."
if [ ! -d "/usr/share/sddm/themes/sugar-candy" ]; then
    sudo mkdir -p /usr/share/sddm/themes/sugar-candy
    git clone https://github.com/Kangie/sddm-sugar-candy.git /tmp/sugar-candy
    sudo cp -r /tmp/sugar-candy/* /usr/share/sddm/themes/sugar-candy/
fi

# Kopiowanie tapety do SDDM
if [ -f "./wallpapers/mecha.jpg" ]; then
    echo "🖼️ Ustawianie tapety SDDM..."
    sudo cp "./wallpapers/mecha.jpg" /usr/share/sddm/themes/sugar-candy/Backgrounds/mecha.jpg
    
    # Tworzenie pliku konfiguracyjnego motywu
    sudo bash -c 'cat > /usr/share/sddm/themes/sugar-candy/theme.conf <<EOF
[General]
Background="Backgrounds/mecha.jpg"
ScreenWidth=1920
ScreenHeight=1080
BlurRadius=20
FormPosition="left"
HaveFormBackground=true
PartialBlur=true
MainColor="white"
AccentColor="#d3d3d3"
BackgroundColor="#2d2d2d"
RoundCorners=20
Font="JetBrainsMono Nerd Font"
FontSize=14
EOF'
fi

# Aktywacja motywu
echo "[Theme]
Current=sugar-candy" | sudo tee /etc/sddm.conf

# 3. Kopiowanie Dotfiles (Konfiguracja użytkownika)
echo "📂 Kopiowanie plików konfiguracyjnych..."
mkdir -p ~/.config
cp -r ./.config/* ~/.config/
chmod +x ~/.config/hypr/scripts/*.sh
chmod +x ~/.config/waybar/scripts/*.sh

# 4. Ustawienie GTK (Dark Mode)
echo "🌑 Ustawianie ciemnego motywu GTK..."
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# 5. Zmiana powłoki na Fish
echo "🐟 Zmiana domyślnej powłoki na Fish..."
if [ "$SHELL" != "/usr/bin/fish" ]; then
    chsh -s /usr/bin/fish
fi

echo "✅ Instalacja zakończona sukcesem!"
echo "➡️  Zrestartuj komputer, aby zalogować się do Hyprland."

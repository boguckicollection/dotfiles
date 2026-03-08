#!/bin/bash

# --- Hyprland & Dotfiles Installer for Ubuntu/Debian ---
# Autor: Bogoos & Sisyphus
# Wersja: 2.0 (Full Auto)

set -e # Przerwij w razie błędu

echo "🚀 Rozpoczynam instalację środowiska Hyprland..."

# 0. Dodanie PPA dla Hyprland (Ubuntu 24.04)
echo "📦 Dodawanie PPA Hyprland..."
sudo add-apt-repository -y ppa:hyprland/stable || true
sudo apt update

# 1. Aktualizacja systemu i instalacja zależności
echo "📦 Aktualizacja repozytoriów..."
sudo apt update && sudo apt upgrade -y

echo "📦 Instalacja wymaganych pakietów..."
# Podstawowe narzędzia
sudo apt install -y git curl wget build-essential unzip tar fastfetch htop jq bc

# Hyprland i środowisko graficzne (Część 1 - główne pakiety)
sudo apt install -y hyprland waybar rofi wofi sway-notification-center swaybg swaylock swayidle hyprpaper \
    polkit-kde-agent-1 xdg-desktop-portal-hyprland \
    brightnessctl playerctl pamixer pavucontrol

# Hyprland dodatki (mogą wymagać PPA lub instalacji ręcznej)
echo "📦 Instalacja dodatków Hyprland..."
sudo apt install -y hypridle hyprlock 2>/dev/null || echo "⚠️ hypridle/hyprlock niedostępne - zainstaluj ręcznie"

# Powiadomienia (używamy sway-notification-center zamiast mako)
echo "📦 Konfiguracja powiadomień..."

# Stylizacja Qt5
sudo apt install -y qt5ct || true
sudo apt install -y qt5-style-kvantum 2>/dev/null || echo "⚠️ qt5-style-kvantum niedostępne"

# Terminal i Shell
sudo apt install -y fish alacritty

# Czcionki
sudo apt install -y fonts-font-awesome fonts-jetbrains-mono fonts-noto-color-emoji fonts-powerline

# Nerd Fonts (wymagane dla ikon w waybar/rofi)
echo "📦 Instalacja Nerd Fonts..."
mkdir -p ~/.local/share/fonts
cd /tmp
curl -fLo "JetBrainsMono.zip" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip
unzip -o JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMono
rm JetBrainsMono.zip
fc-cache -f -v

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

# Instrukcja przywracania dotfiles (Ubuntu -> Debian 13)

Ten folder zawiera konfiguracje dla: Hyprland, Waybar, Alacritty, Rofi oraz Fish.

## Przed instalacją Debiana (na Ubuntu)
Upewnij się, że Twoje repozytorium jest na GitHubie:
1. `gh auth login`
2. `cd ~/dotfiles`
3. `gh repo create dotfiles --public --source=. --remote=origin --push` (jeśli jeszcze nie istnieje)
4. `git push origin master` (aby wysłać najnowsze zmiany)

## Po instalacji Debiana 13

### 1. Instalacja niezbędnych pakietów
Otwórz terminal i zainstaluj wymagane oprogramowanie:
```bash
sudo apt update
sudo apt install git hyprland waybar alacritty rofi fish blueman fonts-inter fonts-font-awesome
```

### 2. Pobranie i instalacja konfiguracji
```bash
git clone https://github.com/TWOJA_NAZWA_UZYTKOWNIKA/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

### 3. Dodatkowe uwagi
- **Ghostty**: W Twojej konfiguracji Hyprland terminal jest ustawiony na `ghostty`. Jeśli nie zainstalujesz go na Debianie, zmień `$terminal` w `~/.config/hypr/hyprland.conf` na `alacritty`.
- **Bluetooth**: Pamiętaj o uruchomieniu apletu Bluetooth, jeśli chcesz mieć go w zasobniku systemowym: `exec-once = blueman-applet` w `hyprland.conf`.

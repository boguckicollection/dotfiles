# Hyprland Full System Backup

Pełny backup konfiguracji systemu (bez danych wrażliwych).

## Co zawiera

- `.config/` - Konfiguracje: Hyprland, Waybar, Rofi, Alacritty, Fish, GTK, Kitty, Ghostty, Brave, QuteBrowser, htop
- `wallpapers/` - 45 tapet
- `scripts/` - Skrypty użytkownika (.local/bin)
- `.bashrc`, `.profile`, `.gitconfig` - Konfiguracja powłoki
- `dconf-backup.ini` - Ustawienia systemowe GNOME
- `install.sh` - Automatyczny instalator

## Bezpieczeństwo

**NIE zawiera:**
- Kluczy SSH (`~/.ssh/`)
- Haseł i sekretów
- Historii shell (`~/.bash_history`)
- Danych przeglądarek (cookies, hasła, historia)
- Plików cache
- Pobranych plików

## Instalacja

```bash
git clone https://github.com/TWOJ_USER/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

Po instalacji pamiętaj o:
1. Wygenerowaniu nowych kluczy SSH
2. Skopiowaniu sekretów (jeśli potrzebne)

## Aktualizacja backupu

Aby zaktualizować backup na nowym komputerze po zmianach:

```bash
# Zaktualizuj dconf
dconf dump / > ~/dotfiles/dconf-backup.ini

# Zsyncuj nowe configi (rsync z exclusions)
rsync -av --exclude='.cache' --exclude='.ssh' --exclude='.bash_history' \
    --exclude='gnupg' --exclude='*.key' --exclude='*.pem' \
    ~/.config/ ~/dotfiles/.config/
```

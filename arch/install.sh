#!/usr/bin/env bash
set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/dotfiles}"
PKG="arch"
SRC="$DOTFILES/$PKG/home/vi"

packages=(
  sway
  xorg-xwayland
  uwsm
  i3status-rust
  wofi
  swaync
  polkit-gnome
  xdg-desktop-portal-wlr
  grim
  slurp
  brightnessctl
  kwallet
  kwallet-pam
  libsecret
  pipewire-alsa
  rtkit
  swaybg
  stow
)

if command -v paru >/dev/null 2>&1; then
  paru -S --needed --noconfirm "${packages[@]}"
else
  sudo pacman -S --needed --noconfirm "${packages[@]}"
fi

for pamfile in /usr/lib/pam.d/plasmalogin /etc/pam.d/login; do
  if [ -f "$pamfile" ] && grep -q pam_gnome_keyring "$pamfile"; then
    sudo cp -n "$pamfile" "$pamfile.pre-kwallet"
    sudo sed -i '/pam_gnome_keyring/d' "$pamfile"
    echo "==> removed pam_gnome_keyring from $pamfile"
  fi
done

sudo install -d /usr/local/share/dbus-1/services
printf '%s\n' \
  '[D-BUS Service]' \
  'Name=org.freedesktop.secrets' \
  'Exec=/usr/bin/ksecretd' \
  | sudo tee /usr/local/share/dbus-1/services/org.freedesktop.secrets.service >/dev/null
echo "==> pinned org.freedesktop.secrets activation to ksecretd"

sudo install -d /usr/local/share/wayland-sessions
sudo tee /usr/local/share/wayland-sessions/sway-uwsm.desktop >/dev/null <<'EOF'
[Desktop Entry]
Name=Sway (uwsm)
Comment=An i3-compatible Wayland compositor, managed by uwsm
Exec=uwsm start -- sway.desktop
DesktopNames=sway
Type=Application
EOF


cp -r "$DOTFILES/nixos/home-manager/config/wallpapers" ~/.config/

stamp="$(date +%Y%m%d-%H%M%S)"
backup="$HOME/.dotfiles-backup-$stamp"

mapfile -t entries < <(
  cd "$SRC" || exit 1
  find . -mindepth 1 -maxdepth 1 -type f -printf '%P\n'
  find ./.config -mindepth 1 -maxdepth 1 -printf '.config/%P\n'
)

for rel in "${entries[@]}"; do
  target="$HOME/$rel"
  if [ -f "$target" ] && [ ! -L "$target" ]; then
    mkdir -p "$backup/$(dirname "$rel")"
    mv "$target" "$backup/$rel"
    echo "==> backed up $rel -> $backup/$rel"
  fi
done

sudo stow -R -d "$DOTFILES" -t / "$PKG"

systemctl --user enable --now pipewire.socket pipewire-pulse.socket wireplumber.service 2>/dev/null || true
systemctl --user enable --now ssh-agent.service 2>/dev/null || true

echo "ok dok"
if [ -d "$backup" ]; then echo "backups @ $backup"; fi

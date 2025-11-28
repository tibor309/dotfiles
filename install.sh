#!/usr/bin/env bash
set -euo pipefail

info() { printf "\n[INFO] %s\n" "$*"; }
err()  { printf "\n[ERROR] %s\n" "$*"; }

WORKDIR="$(mktemp -d)"
trap 'rm -rf "${WORKDIR}"' EXIT

# Detect package manager
if command -v dnf >/dev/null 2>&1; then
    PKG_INSTALL="sudo dnf install -y --best --skip-unavailable"
elif command -v apt-get >/dev/null 2>&1; then
    PKG_INSTALL="sudo apt-get update && sudo apt-get install -y"
else
    err "Unsupported package manager. Please install dependencies manually."
    exit 1
fi

info "Installing system packages (may prompt for sudo)"
${PKG_INSTALL} unzip git zsh fish eza neofetch alacritty gnome-browser-connector gnome-extensions-app gnome-tweaks curl rsync unzip

# Verify required commands
for cmd in git unzip rsync curl fc-cache; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        err "Required command '$cmd' not found. Aborting."
        exit 1
    fi
done

info "Downloading resources to temporary directory: ${WORKDIR}"
COLLOID_DIR="$WORKDIR/Colloid-icon-theme"
git clone --depth 1 "https://github.com/vinceliuice/Colloid-icon-theme.git" "$COLLOID_DIR"
FIRA_ZIP="$WORKDIR/FiraCode.zip"
CATPPUCCIN_ZIP="$WORKDIR/catppuccin-mocha-mauve-standard+default.zip"
curl -fSL -o "$FIRA_ZIP" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
curl -fSL -o "$CATPPUCCIN_ZIP" "https://github.com/catppuccin/gtk/releases/latest/download/catppuccin-mocha-mauve-standard+default.zip"

info "Installing fonts to user fonts directory"
mkdir -p "$HOME/.local/share/fonts"
unzip -qq "$FIRA_ZIP" '*.ttf' -d "$HOME/.local/share/fonts/"

info "Refreshing user font cache"
fc-cache -f

info "Installing themes and configs"
mkdir -p "$HOME/.themes" "$HOME/.config"
rsync -a --ignore-existing --backup --suffix=.bak ./themes/ "$HOME/.themes/"
rsync -a --ignore-existing --backup --suffix=.bak ./config/ "$HOME/.config/"

info "Installing Colloid icon theme"
if [ -x "$COLLOID_DIR/install.sh" ]; then
    (cd "$COLLOID_DIR" && ./install.sh)
else
    info "Colloid installer not executable; copying icons to ~/.local/share/icons"
    mkdir -p "$HOME/.local/share/icons"
    rsync -a "$COLLOID_DIR/" "$HOME/.local/share/icons/Colloid-icon-theme/"
fi

info "Unpacking Catppuccin GTK theme for user"
unzip -qq "$CATPPUCCIN_ZIP" -d "$HOME/.themes"
mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"
if [ -d "$HOME/.themes/catppuccin-mocha-mauve-standard+default/gtk-3.0" ]; then
    rsync -a --ignore-existing "$HOME/.themes/catppuccin-mocha-mauve-standard+default/gtk-3.0/" "$HOME/.config/gtk-3.0/"
fi
if [ -d "$HOME/.themes/catppuccin-mocha-mauve-standard+default/gtk-4.0" ]; then
    rsync -a --ignore-existing "$HOME/.themes/catppuccin-mocha-mauve-standard+default/gtk-4.0/" "$HOME/.config/gtk-4.0/"
fi

info "Installing Starship"
if ! command -v starship >/dev/null 2>&1; then
    curl -fsSL https://starship.rs/install.sh | sh -s -- -y
else
    info "Starship already installed; skipping"
fi

info "Installing mcfly"
if ! command -v mcfly >/dev/null 2>&1; then
    curl -fsSL https://raw.githubusercontent.com/cantino/mcfly/master/ci/install.sh | sudo sh -s -- --git cantino/mcfly
else
    info "mcfly already installed; skipping"
fi

info "Applying per-user Flatpak overrides"
if command -v flatpak >/dev/null 2>&1; then
    flatpak override --user --filesystem="$HOME/.themes"
    flatpak override --user --filesystem="$HOME/.local/share/icons"
    flatpak override --user --env=GTK_THEME="catppuccin-mocha-mauve-standard+default"
    flatpak override --user --env=ICON_THEME="Colloid-Dark"
else
    info "flatpak not found; skipping flatpak overrides"
fi

info "Finished. Open GNOME Tweaks and apply the new theme and icons. You may need to restart your session."


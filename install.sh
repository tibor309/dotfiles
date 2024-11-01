#!/bin/bash

echo "Installing packages"
sudo dnf install -y --best -y \
    unzip \
    git \
    zsh \
    fish \
    eza \
    neofetch \
    alacritty \
    gnome-browser-connector \
    gnome-extensions-app \
    gnome-tweaks 

curl -sS "https://starship.rs/install.sh" | sudo sh # install starship
curl -LSfs "https://raw.githubusercontent.com/cantino/mcfly/master/ci/install.sh" | sudo sh -s --git "cantino/mcfly" # install mcfly


echo "Installing fonts"
wget -vO "/tmp/FiraCode.zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip"
mkdir -p "$HOME/.local/share/fonts"
unzip "/tmp/FiraCode.zip" "*.ttf" -d "$HOME/.local/share/fonts/"
sudo fc-cache -fv

echo "Installing theme"
mkdir "$HOME/.themes"
mkdir -p "$HOME/.config/gtk-4.0"
cp -r "./themes"/* "$HOME/.themes/"
cp -r "./config"/* "$HOME/.config/"

git clone "https://github.com/vinceliuice/Colloid-icon-theme.git" "/tmp/Colloid-icon-theme" # install colloid icon theme
/tmp/Colloid-icon-theme/install.sh
wget -vO "/tmp/catppuccin-mocha-mauve-standard+default.zip" "https://github.com/catppuccin/gtk/releases/download/v1.0.3/catppuccin-mocha-mauve-standard+default.zip"
unzip "/tmp/catppuccin-mocha-mauve-standard+default.zip" "$HOME/.themes/"
cp -r "./themes/catppuccin-mocha-mauve-standard+default/gtk-3.0"/* "$HOME/.config/gtk-3.0/"
cp -r "./themes/catppuccin-mocha-mauve-standard+default/gtk-4.0"/* "$HOME/.config/gtk-4.0/"

echo "Setting flatpak overrides"
sudo flatpak override --filesystem=$HOME/.themes
sudo flatpak override --filesystem=$HOME/.local/share/icons
sudo flatpak override --env=GTK_THEME="catppuccin-mocha-mauve-standard+default"
sudo flatpak override --env=ICON_THEME="Colloid-Dark"

echo "Cleaning up"
sudo dnf autoremove -y
sudo dnf clean all
sudo rm -rf \
    /$HOME/.cache \
    /tmp/*

echo "DONE"
echo "Restart or relog to apply changes"


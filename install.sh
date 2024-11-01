#!/bin/bash

echo -e "\nInstalling packages"
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

echo -e "\nInstalling starship"
curl -sS "https://starship.rs/install.sh" | sudo sh

echo -e "\nInstalling mcfly"
curl -LSfs "https://raw.githubusercontent.com/cantino/mcfly/master/ci/install.sh" | sudo sh -s -- --git cantino/mcfly # install mcfly

echo -e "\nDownloading files to /tmp"
git clone "https://github.com/vinceliuice/Colloid-icon-theme.git" "/tmp/Colloid-icon-theme"
wget -vO "/tmp/FiraCode.zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip"
wget -vO "/tmp/catppuccin-mocha-mauve-standard+default.zip" "https://github.com/catppuccin/gtk/releases/download/v1.0.3/catppuccin-mocha-mauve-standard+default.zip"

echo -e "\nInstalling fonts"
mkdir -p "$HOME/.local/share/fonts"
unzip "/tmp/FiraCode.zip" "*.ttf" -d "$HOME/.local/share/fonts/"

echo -e "\nRefreshing font cache"
sudo fc-cache -fv

echo -e "\nInstalling theme"
mkdir -p "$HOME/.themes"
mkdir -p "$HOME/.config/gtk-4.0"
cp -r "./themes"/* "$HOME/.themes/"
cp -r "./config"/* "$HOME/.config/"

/tmp/Colloid-icon-theme/install.sh # install colloid icon theme
unzip "/tmp/catppuccin-mocha-mauve-standard+default.zip" -d "$HOME/.themes/"
cp -r "$HOME/.themes/catppuccin-mocha-mauve-standard+default/gtk-3.0"/* "$HOME/.config/gtk-3.0/"
cp -r "$HOME/.themes/catppuccin-mocha-mauve-standard+default/gtk-4.0"/* "$HOME/.config/gtk-4.0/"

echo -e "\nSetting flatpak overrides"
sudo flatpak override --filesystem=$HOME/.themes
sudo flatpak override --filesystem=$HOME/.local/share/icons
sudo flatpak override --env=GTK_THEME="catppuccin-mocha-mauve-standard+default"
sudo flatpak override --env=ICON_THEME="Colloid-Dark"

echo -e "\nCleaning up"
sudo dnf autoremove -y
sudo dnf clean all
sudo rm -rf \
    /$HOME/.cache \
    /tmp/*

echo -e "\nDONE!\nApply the new theme in GNOME Tweaks!"


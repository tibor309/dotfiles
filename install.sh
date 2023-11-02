#!/bin/bash

echo Removing preinstalled apps
sudo dnf remove totem gnome-photos gnome-clocks gnome-calendar gnome-contacts gnome-weather gnome-calculator gnome-boxes gnome-remote-desktop gnome-connections gnome-todo gnome-tour gnome-text-editor gnome-maps -y
sudo dnf remove rhythmbox libreoffice-calc libreoffice-writer libreoffice-impress yelp eog cheese firefox mediawriter simple-scan loupe -y

echo Installing flatpaks
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo # Add flatpak repo

# Install flatpaks
flatpak install --noninteractive com.mattjakeman.ExtensionManager ca.desrt.dconf-editor io.github.realmazharhussain.GdmSettings # theme
flatpak install --noninteractive org.gnome.Calculator org.gnome.Calendar org.gnome.FileRoller org.gnome.Weather org.gnome.Loupe org.gnome.TextEditor # gnome

flatpak install --noninteractive com.belmoussaoui.Obfuscate com.github.tchx84.Flatseal com.mojang.Minecraft com.valvesoftware.Steam io.bassi.Amberol org.gnome.Boxes io.gitlab.news_flash.NewsFlash
flatpak install --noninteractive com.discordapp.Discord org.gimp.GIMP org.inkscape.Inkscape org.libreoffice.LibreOffice org.mozilla.firefox org.remmina.Remmina org.telegram.desktop com.hunterwittenborn.Celeste

# Fix firefox gestures
flatpak override --env=MOZ_ENABLE_WAYLAND=1 org.mozilla.firefox


# Update system and install packages
echo Updating system
sudo dnf update -y

echo Installing packages
sudo dnf install wget unzip dconf gnome-extensions-app gnome-tweaks -y
sudo dnf install zsh fish alacritty fira-code-fonts eza neofetch gnome-browser-connector -y
sudo dnf install libgda gsound -y

curl -sS https://starship.rs/install.sh | sudo sh # install starship
curl -LSfs https://raw.githubusercontent.com/cantino/mcfly/master/ci/install.sh | sudo sh -s -- --git cantino/mcfly # install mcfly

echo Downloading files
echo The files can be found in your downloads folder!
git clone https://github.com/vinceliuice/Colloid-icon-theme.git ~/Downloads/Colloid-icon-theme
git clone https://github.com/AdnanHodzic/auto-cpufreq.git ~/Downloads/auto-cpufreq
wget https://github.com/catppuccin/gtk/releases/download/v0.7.0/Catppuccin-Mocha-Standard-Mauve-Dark.zip -P ~/Downloads
wget https://mega.nz/linux/repo/Fedora_39/x86_64/megasync-Fedora_39.x86_64.rpm -P ~/Downloads
wget https://mega.nz/linux/repo/Fedora_39/x86_64/nautilus-megasync-Fedora_39.x86_64.rpm -P ~/Downloads

echo Installing MEGASync
sudo dnf install ~/Downloads/megasync-Fedora_39.x86_64.rpm -y
sudo dnf install ~/Downloads/nautilus-megasync-Fedora_39.x86_64.rpm -y

echo Configuring library folders for MEGASync
# Symlink mega folder to library folders
mkdir ~/MEGA ~/MEGA/Documents ~/MEGA/Pictures ~/MEGA/Music ~/MEGA/Videos
rmdir ~/Documents ~/Pictures ~/Music ~/Videos
ln -s ~/MEGA/Music/ ~/Music
ln -s ~/MEGA/Pictures/ ~/Pictures
ln -s ~/MEGA/Documents/ ~/Documents
ln -s ~/MEGA/Videos/ ~/Videos

echo Installing auto-cpufreq
sudo dnf install gobject-introspection-devel cairo-devel cairo-gobject-devel -y
sudo ~/Downloads/auto-cpufreq-master/auto-cpufreq-installer

echo Installing themes
# Copy themes
mkdir $HOME/.themes
cp -r themes/* $HOME/.themes/
cp -r config/* $HOME/.config/

flatpak override --filesystem=$HOME/.themes
flatpak override --env=GTK_THEME=Catppuccin-Mocha-Standard-Mauve-Dark

unzip ~/Downloads/Catppuccin-Mocha-Standard-Mauve-Dark.zip -d ~/.themes
~/Downloads/Colloid-icon-theme/install.sh # Launch install script

echo Installing fonts
mkdir $HOME/.local/share/fonts
cp -r fonts/* $HOME/.local/share/fonts

echo Updating font cache
sudo fc-cache -fv

# Set themes for flatpaks
flatpak override --filesystem=$HOME/.themes
flatpak override --env=GTK_THEME='Catppuccin-Mocha-Standard-Mauve-Dark'

mkdir -p "~/.config/gtk-4.0"
cp -r Catppuccin-Mocha-Standard-Mauve-Dark/gtk-4.0/* ~/.config/gtk-4.0/

# Update font cache

echo DONE
echo Restart to apply changes


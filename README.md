# 🎨 Mauve
This theme is a modified version of [ART3MISTICAL](https://github.com/ART3MISTICAL/dotfiles)'s second rice. It mainly focuses on tiling window management, and uses the Catppuccin Mocha Mauve theme with Colloid icons.

> [!WARNING]
> This setup was originally made for Fedora 39. Themes and configs might not work properly on other versions/distros.

## Packages

- git
- unzip
- rsync
- curl
- zsh
- fish
- eza *(supported until Fedora 41)*
- neofetch *(supported until Fedora 41)*
- alacritty
- gnome-browser-connector
- gnome-extensions-app
- gnome-tweaks

## Extensions

- [User Themes](https://extensions.gnome.org/extension/19/user-themes)
- [Logo Menu](https://extensions.gnome.org/extension/4451/logo-menu)
- [Rounded Window Corners](https://extensions.gnome.org/extension/5237/rounded-window-corners)
- [Compiz Window Effecct](https://extensions.gnome.org/extension/3210/compiz-windows-effect)
- [Forge](https://extensions.gnome.org/extension/4481/forge)
- [Just Perfection](https://extensions.gnome.org/extension/3843/just-perfection)

## Setup

### Script *(recommended)*
The script is compatible with Fedora and Ubuntu based systems. This will install all the required packages, and applies the theme for gtk3/4 and Flatpak apps. You have to install the GNOME extensions manually!

```sh
git clone -b mauve https://github.com/tibor309/dotfiles.git
cd dotfiles/
./install.sh
```

### Manual

1. Install the above mentioned packages, and GNOME extensions
2. Install Starship, mcfly, and FiraCode Nerd Fonts
3. Install the Catppuccin Mocha Mauve GTK theme, and the Colloid Dark icon theme
3. Download the repository
4. Copy the contents of the config folder to your `~/.config` folder (you might want to backup your existing configs first)
5. Copy the contents of the themes folder to your `~/.themes` folder (you might want to create it)
6. Set the themes and icons using GNOME Tweaks
  - Set the GNOME Shell theme to the Modded Catppuccin theme
  - Set the applications theme to Catppuccin Mocha Mauve theme
  - Set the icons to Colloid Dark
7. Optionally: Apply Flatpak overrides
8. Restart GNOME Shell or relog

#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Install git and base-devel if they are not already installed
sudo pacman -Syu --needed --noconfirm git base-devel || { echo "Failed to install dependencies."; exit 1; }

# Clone yay repository
git clone https://aur.archlinux.org/yay.git || { echo "Failed to clone Yay repository."; exit 1; }

# Change to the yay directory
cd yay || { echo "Failed to change directory to Yay."; exit 1; }

# Build and install yay
makepkg -si --noconfirm || { echo "Failed to build or install Yay."; exit 1; }

# Remove the yay directory after installation
cd .. && rm -rf yay || { echo "Failed to remove Yay directory."; exit 1; }

echo "YAY! installation completed successfully!"

# Update system and yay
yay -Syu --noconfirm || { echo "Failed to update system."; exit 1; }

# Install Brave Browser, alacritty (terminal), neovim (code editor) using yay
yay -S --noconfirm brave-bin neovim || { echo "Failed to install packages."; exit 1; }
yay -S --needed thunar alacritty
echo "Brave Browser, Alacritty, Thunar, and Neovim installation completed successfully!"

# Setup NeoVim Config & i3 Config
git clone https://github.com/itzkavishka/neovim_alacritty.git ~/ || { echo "Clone failed"; exit 1; }

cd ~/neovim_alacritty || { echo "Directory not found"; exit 1; }

mkdir -p ~/.config/i3/
mkdir -p ~/.config/alacritty
mkdir -p ~/.config/nvim 
mkdir -p ~/.local/share/fonts/jetbrains/
# Copy Alacritty configuration to its respective directory
cp alacritty/alacritty.toml ~/.config/alacritty/ || { echo "Copy failed"; exit 1; }

cp -r ~/neovim_alacritty/fonts/* ~/.local/share/fonts/jetbrains/

fc-cache -f -v | grep "fc-cache"

rsync -av --exclude='alacritty' --exclude='fonts' ./ ~/.config/nvim/ || { echo "Copy failed"; exit 1; }

# i3 Config
wget -q --show-progress --retry-connrefused --waitretry=1 --timeout=30 https://raw.githubusercontent.com/itzkavishka/i3/main/config || { echo "Download failed"; exit 1; }

cp config ~/.config/i3/ || { echo "Copy failed" ; exit 1; }

cd ~ && rm -rf neovim_alacritty

echo "Setup completed successfully."

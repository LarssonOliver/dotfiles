#!/bin/bash

USERNAME=oliver

# Install pacman packages
pacman -S - < $(dirname "$0")/packages.txt

# Install yay
sudo -u ${USERNAME} git clone https://aur.archlinux.org/yay.git /tmp/yay
pushd /tmp/yay
sudo -u ${USERNAME} makepkg -si
popd
sudo -u ${USERNAME} rm -rf /tmp/yay

# Install aur packages
sudo -u ${USERNAME} yay lightdm-webkit-theme-aether

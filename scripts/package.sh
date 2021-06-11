#!/bin/bash

USERNAME=oliver

pacman -S - < $(dirname "$0")/packages.txt

sudo -u ${USERNAME} git clone https://aur.archlinux.org/yay.git /tmp/yay
pushd /tmp/yay
sudo -u ${USERNAME} makepkg -si
popd
sudo -u ${USERNAME} rm -rf /tmp/yay

sudo -u ${USERNAME} yay lightdm-webkit-theme-aether

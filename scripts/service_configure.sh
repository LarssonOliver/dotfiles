#!/bin/bash

systemctl enable dhcpcd
systemctl start dhcpcd

systemctl enable iwd
systemctl start iwd

printf "[device]\nwifi.backend=iwd\n" > /etc/NetworkManager/NetworkManager.conf
systemctl enable NetworkManager
systemctl start NetworkManager

systemctl enable sshd
systemctl start sshd

systemctl enable systemd-homed
systemctl start  systemd-homed

systemctl enable systemd-networkd
systemctl start  systemd-networkd

systemctl enable systemd-resolved
systemctl start  systemd-resolved

systemctl enable systemd-timesyncd
systemctl start  systemd-timesyncd

systemctl enable lightdm

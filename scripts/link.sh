#!/bin/bash

########################################
# Script that links all config files.
########################################

SCRIPTNAME=$(basename "$0")
SRCDIR=$(dirname "$0")/..
CONFDIR=${HOME}/.config

echo "${SCRIPTNAME}: Linking home directory files..."
ln -srv ${SRCDIR}/.bash_aliases ${HOME}
ln -srv ${SRCDIR}/.bashrc ${HOME}
ln -srv ${SRCDIR}/.gtkrc-2.0 ${HOME}
ln -srv ${SRCDIR}/.vimrc ${HOME}

echo "${SCRIPTNAME}: Linking \".local/share\" directories..."
mkdir -vp ${HOME}/.local/share/fonts
ln -srv ${SRCDIR}/fonts/* ${HOME}/.local/share/fonts

mkdir -vp ${HOME}/.local/share/icons
ln -srv ${SRCDIR}/icons/* ${HOME}/.local/share/icons

mkdir -vp ${HOME}/.local/share/themes
ln -srv ${SRCDIR}/themes/* ${HOME}/.local/share/themes

echo "${SCRIPTNAME}: Linking \".config\" directory files..."
mkdir -vp ${CONFDIR}
ln -srv ${SRCDIR}/.config/* ${CONFDIR}




#!/usr/bin/env bash

# Bootstrap homebrew if on mac.
if [[ $(uname -s) == "Darwin" ]]; then
    (
        cd macos || exit
        sh bootstrap.sh
    )
fi

# Check if oh-my-zsh is installed
OMZDIR="$HOME/.oh-my-zsh"
if [ ! -d "$OMZDIR" ]; then
  /bin/sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  cd "$OMZDIR" || exit
  tools/upgrade.sh
fi

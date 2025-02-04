#!/usr/bin/env sh

git submodule sync --recursive
git submodule update --init --recursive

git clean -ffdx \
    zsh/plugins/

if command -v yabai > /dev/null; then
    yabai --start-service
fi

if command -v skhd > /dev/null; then
    skhd --start-service
fi

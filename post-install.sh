#!/usr/bin/env sh

git submodule sync --recursive
git submodule update --init --recursive

git clean -ffdx \
    zsh/plugins/

if command -v skhd > /dev/null; then
    skhd --start-service
fi

# Install tmux plugins (tpm itself is a git submodule, but the plugins it
# manages are not vendored and need to be fetched on every new machine).
if command -v tmux > /dev/null; then
    "$HOME/.tmux/plugins/tpm/scripts/install_plugins.sh"
fi

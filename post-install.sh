#!/usr/bin/env sh

git submodule sync --recursive
git submodule update --init --recursive

git clean -ffdx \
    zsh/plugins/

if command -v nvim > /dev/null; then
    echo "Running NeoVim PackerSync"
    nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
fi

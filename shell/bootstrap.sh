#!/usr/bin/sh

# Add paths to system PATH.
path_prepend "$HOME/.local/bin"

# Check if neovim is installed, otherwise default to vim.
if ! command -v nvim > /dev/null; then
    export EDITOR=vim
else
    export EDITOR=nvim
fi

# Check for dotfiles updates once after reboot.
HAS_CHECKED_DOTFILES_PATH="/tmp/.dotstat_done"
if [ ! -f "$HAS_CHECKED_DOTFILES_PATH" ]; then 
    (dotstat_dotfiles_check_and_notify &)
    (dotstat_bootstrap_check_and_notify &)
    touch $HAS_CHECKED_DOTFILES_PATH
fi


#!/usr/bin/sh

# Add paths to system PATH.
path_prepend "$HOME/.local/bin"

if [[ "$(uname -s)" == "Darwin" ]]; then
   eval "$(/opt/homebrew/bin/brew shellenv)"

   # For zathura.
   export DBUS_SESSION_BUS_ADDRESS="unix:path=$DBUS_LAUNCHD_SESSION_BUS_SOCKET"
elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
   eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Same condition as is-headless.sh, which isn't reachable from ~/.shell.
if [[ "$(uname -s)" == "Linux" && -z "${DISPLAY:-}" && -z "${WAYLAND_DISPLAY:-}" ]]; then
    export TERM=xterm-256color
fi

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


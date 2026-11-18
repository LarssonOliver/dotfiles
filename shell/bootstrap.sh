#!/usr/bin/sh

# Add paths to system PATH.
path_prepend "$HOME/.local/bin"
path_prepend "${KREW_ROOT:-$HOME/.krew}/bin"

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


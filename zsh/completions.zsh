# ZSH CLI Completions
if command -v talosctl &> /dev/null; then
    eval "$(talosctl completion zsh)"
fi

if command -v talhelper &> /dev/null; then
    eval "$(talhelper completion zsh)"
fi

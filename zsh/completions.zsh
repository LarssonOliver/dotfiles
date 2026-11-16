# ZSH CLI Completions
if command -v talosctl &> /dev/null; then
    eval "$(talosctl completion zsh)"
fi

if command -v talhelper &> /dev/null; then
    eval "$(talhelper completion zsh)"
fi

if command -v sops &> /dev/null; then
    eval "$(sops completion zsh)"
fi

if command -v tsh &> /dev/null; then
    # tsh emits a bogus first block defining `_`, which breaks under aliases; keep only the tsh block.
    eval "$(tsh --completion-script-zsh | sed -n '/^#compdef tsh/,$p')"
fi

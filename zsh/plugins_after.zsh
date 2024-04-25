# Bind ctrl+space to accept autosuggestion.
bindkey '^ ' autosuggest-accept

# Setup Atuin if it's installed.
if command -v atuin &> /dev/null; then
    eval "$(atuin init zsh --disable-up-arrow)"
    eval "$(atuin gen-completions --shell zsh)"
fi

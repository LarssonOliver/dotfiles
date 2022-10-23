if command -v starship >/dev/null; then
	eval "$(starship init zsh)"
else
	echo "Starship not installed, using default prompt"
fi

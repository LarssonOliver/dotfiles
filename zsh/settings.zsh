export ZSH="$HOME/.oh-my-zsh"

plugins=(
	git
	dotenv
	ssh-agent
    tmux

    zsh-history-substring-search
    zsh-autosuggestions

    # Import this last
	zsh-syntax-highlighting
)

zstyle ':omz:update' mode reminder

# zsh-completions only adds completion functions; loading it as a plugin
# makes oh-my-zsh rebuild .zcompdump. See its README.
fpath+=(${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-completions/src)

source $ZSH/oh-my-zsh.sh


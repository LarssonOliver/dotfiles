export ZSH="$HOME/.oh-my-zsh"

plugins=(
	git
	dotenv
	ssh-agent
	zsh-completions

    zsh-history-substring-search
    zsh-autosuggestions

    # Import this last
	zsh-syntax-highlighting
)

zstyle ':omz:update' mode reminder

source $ZSH/oh-my-zsh.sh


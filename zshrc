export ZSH="$HOME/.oh-my-zsh"

zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  dotenv
  ssh-agent
  zsh-completions
  zsh-syntax-highlighting
)

zstyle :omz:plugins:ssh-agent lazy yes

source $ZSH/oh-my-zsh.sh

# User configuration

if command -v starship >/dev/null
then
  eval "$(starship init zsh)"
else
  echo "Starship not installed, using default prompt"
fi

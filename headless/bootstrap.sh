#!/usr/bin/env bash

set -e

###############################################################################
# Homebrew                                                                    #
###############################################################################

if ! command -v brew &> /dev/null; then
    # Install Homebrew: https://docs.brew.sh/Installation
    script_url="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
    NONINTERACTIVE=1 /usr/bin/env bash -c "$(curl -fsSL $script_url)"

    if ! command -v brew &>/dev/null; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        command -v brew &>/dev/null || exit 1
    fi
else
    echo "Homebrew already installed."
fi

brew analytics off
brew bundle check || brew bundle

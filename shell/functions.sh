#!/usr/bin/sh

path_remove() {
    PATH=$(echo "$PATH" | awk -v RS=: -v ORS=: "\$0 != \"$1\"" | sed 's/:$//')
}

path_append() {
    path_remove "$1"
    PATH="${PATH:+"$PATH:"}$1"
}

path_prepend() {
    path_remove "$1"
    PATH="$1${PATH:+":$PATH"}"
}

# dotstat helper functions
source ~/.shell/functions/dotstats.sh

dotstat() {
    # Check if git is available
    if ! prog_loc="$(type "git")" || [ -z "$prog_loc" ] || [ "$prog_loc" = "git not found" ]; then
        echo "ERROR: Git does not exist in path! Please ensure git is installed, and try again."
        return
    fi

    # Check for active internet connection
    printf "%s\n\n" "GET http://google.com HTTP/1.0" | nc google.com 80 > /dev/null 2>&1
    if [ $? -eq 1 ]; then
        echo "ERROR: Failed to get status of remote dotfiles. No active internet connection detected!"
        return
    fi

    (dotstat_dotfiles)
    (dotstat_bootstrap)
}

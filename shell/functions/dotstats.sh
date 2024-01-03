#!/usr/bin/sh

# Much of this is thanks to ntpeters on GitHub.
# https://gist.github.com/ntpeters/bb100b43340d9bf8ac48 
#
# Checks the status of local and remote dotfiles repos to determine if they
# need to be synced up.
dotstat_dotfiles() {
    # Ensure a path to the local dotfiles repo has been provided
    if [ -z ${LOCAL_DOTFILES_REPOSITORY+x} ]; then
        echo "ERROR: Must set the 'LOCAL_DOTFILES_REPOSITORY' variable with path to your dotfiles directory!"
        return
    fi

    # Ensure path to dotfiles repo has expanded tilde for home dir
    # Not sure how portable this method is...
    local_dotfiles_repo=$(eval "echo $LOCAL_DOTFILES_REPOSITORY")
    cd "${local_dotfiles_repo}" || return

    # Make sure the path we were given is a git repo
    if [ ! -d ./.git ]; then
        echo "ERROR: Provided dotfile directory is not a git repository!"
        return
    fi

    # Get remote branch info
    git fetch > /dev/null 2>&1

    # Retrieve hashes from git
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse @\{u\})
    BASE=$(git merge-base @ @\{u\})

    # Check for uncommitted changes
    ! git diff-index --quiet HEAD --
    UNCOMMITTED=$?

    # Flag to determine if an update may need to be done
    update=false

    # Determine status of dotfiles
    if [ -z "$LOCAL" ] || [ -z "$REMOTE" ] || [ -z "$BASE" ]; then
        echo "ERROR: Failed to get status of local dotfiles!"
    elif [ $UNCOMMITTED = 0 ]; then
        echo "Local dotfiles have uncommitted changes."
    elif [ "$LOCAL" = "$REMOTE" ]; then
        # Silent exit.
        true
    elif [ "$LOCAL" = "$BASE" ]; then
        echo "Remote dotfiles have changed."
        update=true
    elif [ "$REMOTE" = "$BASE" ]; then
        echo "Local dotfiles have changed."
    else
        echo "WARNING: Local and remote dotfiles have diverged. You may experience merge conflicts!"
    fi

    # See if the user wants to sync dotfiles
    if $update; then
        printf "%s" "Sync dotfiles now? [y/n] "
        read -r REPLY
        if [ "$REPLY" != "${REPLY#[Yy]}" ]; then
            # Pull new changes from remote
            git pull > /dev/null 2>&1
            bash install > /dev/null
        fi
    fi
}

dotstat_bootstrap() {
    # Ensure a path to the local bootstrap repo has been provided
    if [ -z ${LOCAL_BOOTSTRAP_REPOSITORY+x} ]; then
        echo "ERROR: Must set the 'LOCAL_BOOTSTRAP_REPOSITORY' variable with path to your bootstrap directory!"
        return
    fi

    # Ensure path to bootstrap repo has expanded tilde for home dir
    # Not sure how portable this method is...
    local_bootstrap_repo=$(eval "echo $LOCAL_BOOTSTRAP_REPOSITORY")
    cd "${local_bootstrap_repo}" || return

    # Make sure the path we were given is a git repo
    if [ ! -d ./.git ]; then
        echo "ERROR: Provided dotfile directory is not a git repository!"
        return
    fi

    # Get remote branch info
    git fetch > /dev/null 2>&1

    # Retrieve hashes from git
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse @\{u\})
    BASE=$(git merge-base @ @\{u\})

    # Check for uncommitted changes
    ! git diff-index --quiet HEAD --
    UNCOMMITTED=$?

    # Flag to determine if an update may need to be done
    update=false

    # Determine status of bootstrap
    if [ -z "$LOCAL" ] || [ -z "$REMOTE" ] || [ -z "$BASE" ]; then
        echo "ERROR: Failed to get status of local bootstrap!"
    elif [ $UNCOMMITTED = 0 ]; then
        echo "Local bootstrap have uncommitted changes."
    elif [ "$LOCAL" = "$REMOTE" ]; then
        # Silent exit.
        true
    elif [ "$LOCAL" = "$BASE" ]; then
        echo "Remote bootstrap have changed."
        update=true
    elif [ "$REMOTE" = "$BASE" ]; then
        echo "Local bootstrap have changed."
    else
        echo "WARNING: Local and remote bootstrap have diverged. You may experience merge conflicts!"
    fi

    # See if the user wants to sync bootstrap
    if $update; then
        printf "%s" "Sync bootstrap now? [y/n] "
        read -r REPLY
        if [ "$REPLY" != "${REPLY#[Yy]}" ]; then
            # Pull new changes from remote
            git pull > /dev/null 2>&1
            bash install > /dev/null
        fi
    fi
}

dotstat_dotfiles_check_and_notify() {
    # Check if notify-send is present on the system
    if ! command -v notify-send > /dev/null 2>&1; then
        return
    fi

    NOTIFYARGS="--app-name=dotstat"

    ICONPATH="$HOME/.local/share/icons/dotfiles.png"
    if ls "$ICONPATH" > /dev/null 2>&1; then
        ICONARGS="--icon=$ICONPATH"
    else
        ICONARGS=""
    fi

    # Check if git is available
    if ! prog_loc="$(type "git")" || [ -z "$prog_loc" ] || [ "$prog_loc" = "git not found" ]; then
        notify-send $ICONARGS $NOTIFYARGS -u critical "dotstat" "Git could not be found."
        return
    fi

    # Check for active internet connection
    printf "%s\n\n" "GET http://google.com HTTP/1.0" | nc google.com 80 > /dev/null 2>&1
    if [ $? -eq 1 ]; then
        notify-send $ICONARGS $NOTIFYARGS "dotstat" "Failed to get status of remote dotfiles. No active internet connection detected!"
        return
    fi

    # Ensure a path to the local dotfiles repo has been provided
    if [ -z ${LOCAL_DOTFILES_REPOSITORY+x} ]; then
        notify-send $ICONARGS $NOTIFYARGS -u critical "dotstat" "Must set the 'LOCAL_DOTFILES_REPOSITORY' variable with path to your dotfiles directory!"
        return
    fi

    # Ensure path to dotfiles repo has expanded tilde for home dir
    # Not sure how portable this method is...
    local_dotfiles_repo=$(eval "echo $LOCAL_DOTFILES_REPOSITORY")
    cd "${local_dotfiles_repo}" || return

    # Make sure the path we were given is a git repo
    if [ ! -d ./.git ]; then
        notify-send $ICONARGS $NOTIFYARGS -u critical "dotstat" "Provided dotfile directory is not a git repository!"
        return
    fi

    # Get remote branch info
    git fetch > /dev/null 2>&1

    # Retrieve hashes from git
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse @\{u\})
    BASE=$(git merge-base @ @\{u\})

    # Check for uncommitted changes
    ! git diff-index --quiet HEAD --
    UNCOMMITTED=$?

    # Determine status of dotfiles
    if [ -z "$LOCAL" ] || [ -z "$REMOTE" ] || [ -z "$BASE" ]; then
        notify-send $ICONARGS $NOTIFYARGS -u critical "dotstat" "Failed to get status of local dotfiles!"
    elif [ $UNCOMMITTED = 0 ]; then
        notify-send $ICONARGS $NOTIFYARGS "dotstat" "Local dotfiles have uncommitted changes."
    elif [ "$LOCAL" = "$REMOTE" ]; then
        # Silent exit.
        true
    elif [ "$LOCAL" = "$BASE" ]; then
        notify-send $ICONARGS $NOTIFYARGS "dotstat" "Remote dotfiles have changed."
    elif [ "$REMOTE" = "$BASE" ]; then
        notify-send $ICONARGS $NOTIFYARGS "dotstat" "Local dotfiles have changed."
    else
        notify-send $ICONARGS $NOTIFYARGS "dotstat" "WARNING: Local and remote dotfiles have diverged. You may experience merge conflicts!"
    fi
}

dotstat_bootstrap_check_and_notify() {
    # Check if notify-send is present on the system
    if ! command -v notify-send > /dev/null 2>&1; then
        return
    fi

    NOTIFYARGS="--app-name=dotstat"

    ICONPATH="$HOME/.local/share/icons/dotfiles.png"
    if ls "$ICONPATH" > /dev/null 2>&1; then
        ICONARGS="--icon=$ICONPATH"
    else
        ICONARGS=""
    fi

    # Check if git is available
    if ! prog_loc="$(type "git")" || [ -z "$prog_loc" ] || [ "$prog_loc" = "git not found" ]; then
        notify-send $ICONARGS $NOTIFYARGS -u critical "dotstat bootstrap" "Git could not be found."
        return
    fi

    # Check for active internet connection
    printf "%s\n\n" "GET http://google.com HTTP/1.0" | nc google.com 80 > /dev/null 2>&1
    if [ $? -eq 1 ]; then
        notify-send $ICONARGS $NOTIFYARGS "dotstat bootstrap" "Failed to get status of remote bootstrap. No active internet connection detected!"
        return
    fi

    # Ensure a path to the local bootstrap repo has been provided
    if [ -z ${LOCAL_BOOTSTRAP_REPOSITORY+x} ]; then
        notify-send $ICONARGS $NOTIFYARGS -u critical "dotstat bootstrap" "Must set the 'LOCAL_BOOTSTRAP_REPOSITORY' variable with path to your bootstrap directory!"
        return
    fi

    # Ensure path to bootstrap repo has expanded tilde for home dir
    # Not sure how portable this method is...
    local_bootstrap_repo=$(eval "echo $LOCAL_BOOTSTRAP_REPOSITORY")
    cd "${local_bootstrap_repo}" || return

    # Make sure the path we were given is a git repo
    if [ ! -d ./.git ]; then
        notify-send $ICONARGS $NOTIFYARGS -u critical "dotstat bootstrap" "Provided dotfile directory is not a git repository!"
        return
    fi

    # Get remote branch info
    git fetch > /dev/null 2>&1

    # Retrieve hashes from git
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse @\{u\})
    BASE=$(git merge-base @ @\{u\})

    # Check for uncommitted changes
    ! git diff-index --quiet HEAD --
    UNCOMMITTED=$?

    # Determine status of bootstrap
    if [ -z "$LOCAL" ] || [ -z "$REMOTE" ] || [ -z "$BASE" ]; then
        notify-send $ICONARGS $NOTIFYARGS -u critical "dotstat bootstrap" "Failed to get status of local bootstrap!"
    elif [ $UNCOMMITTED = 0 ]; then
        notify-send $ICONARGS $NOTIFYARGS "dotstat bootstrap" "Local bootstrap have uncommitted changes."
    elif [ "$LOCAL" = "$REMOTE" ]; then
        # Silent exit.
        true
    elif [ "$LOCAL" = "$BASE" ]; then
        notify-send $ICONARGS $NOTIFYARGS "dotstat bootstrap" "Remote bootstrap have changed."
    elif [ "$REMOTE" = "$BASE" ]; then
        notify-send $ICONARGS $NOTIFYARGS "dotstat bootstrap" "Local bootstrap have changed."
    else
        notify-send $ICONARGS $NOTIFYARGS "dotstat bootstrap" "WARNING: Local and remote bootstrap have diverged. You may experience merge conflicts!"
    fi
}

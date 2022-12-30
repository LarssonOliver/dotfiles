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
            sh install > /dev/null
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
            sh install > /dev/null
        fi
    fi
}

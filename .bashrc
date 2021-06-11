#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source ~/.bash_aliases
PS1='[\u@\h \W]\$ '

# Enable case insensitive autocomplete in bash
bind 'set completion-ignore-case on'

# Enter fish
if [ -z "$BASH_EXECUTION_STRING" ] && [[ $(ps --no-header --pid=$PPID --format=cmd) != "fish" ]] 
then 
	exec fish
fi


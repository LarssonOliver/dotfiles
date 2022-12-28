#!/usr/bin/sh

alias ls='ls --color=auto'
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'

alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias more=less

alias bat='bat --theme Nord'

alias callgrind='valgrind --tool=callgrind --dump-instr=yes --collect-jumps=yes'
alias cachegrind='valgrind --tool=cachegrind'

if command -v nvim > /dev/null; then
    alias vim='nvim'
fi

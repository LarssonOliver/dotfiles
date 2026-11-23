#!/usr/bin/env bash
# Claude Code hook: marks the tmux window as waiting for input ("set") or
# clears the mark ("clear"). The tmux config highlights windows with the
# @claude_waiting option. No-op outside tmux.
set -euo pipefail

[[ -n "${TMUX_PANE:-}" ]] || exit 0

case "${1:-}" in
  set)
    # No point flagging the window the user is already looking at.
    [[ "$(tmux display -p -t "$TMUX_PANE" '#{window_active}')" == 1 ]] ||
      tmux set-option -w -t "$TMUX_PANE" @claude_waiting 1
    ;;
  clear) tmux set-option -wu -t "$TMUX_PANE" @claude_waiting ;;
  *) echo "usage: $0 set|clear" >&2; exit 1 ;;
esac

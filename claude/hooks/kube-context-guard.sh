#!/usr/bin/env bash
# PreToolUse hook for Claude Code: for mutating kubectl/helm commands, force a
# permission prompt that shows WHICH cluster context the command will hit, and
# block outright when the context looks like production.
#
# Install: ~/.claude/hooks/kube-context-guard.sh  (chmod +x), needs jq.
# Tune PROD_RE to match your naming.
set -euo pipefail

PROD_RE='(^|[-_/.])(prod|prd|production)([-_/.]|$)'

input="$(cat)"
cmd="$(jq -r '.tool_input.command // empty' <<<"$input")"
[[ -z "$cmd" ]] && exit 0

# Only care about kubectl / helm invocations that change something.
mutating='(^|[;&|[:space:]])(kubectl|helm)[[:space:]].*\b(apply|create|replace|delete|patch|edit|scale|label|annotate|rollout[[:space:]]+(restart|undo)|cordon|drain|taint|exec|cp|install|upgrade|uninstall|rollback)\b'
if ! grep -Eq "$mutating" <<<"$cmd"; then
  exit 0
fi

# Context: explicit --context / --kube-context flag wins, else current-context.
ctx="$(grep -Eo -- '--(kube-)?context[= ][^ ]+' <<<"$cmd" | head -n1 | sed -E 's/--(kube-)?context[= ]//' || true)"
if [[ -z "$ctx" ]]; then
  ctx="$(kubectl config current-context 2>/dev/null || echo 'unknown')"
fi

if grep -Eiq "$PROD_RE" <<<"$ctx"; then
  decision="deny"
  reason="Blocked: mutating command against PRODUCTION context '$ctx'. Run it yourself if intended."
else
  decision="ask"
  reason="Mutating command against kube context '$ctx'."
fi

jq -n --arg d "$decision" --arg r "$reason" '{
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    permissionDecision: $d,
    permissionDecisionReason: $r
  }
}'

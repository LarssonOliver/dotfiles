#!/usr/bin/env bash
# PreToolUse hook for Claude Code: mutating commands against clusters, GCP or
# Terraform/OpenTofu always force a permission prompt that shows the resolved
# target, and are blocked outright when anything looks like production.
#
# "Production" means prod or prd anywhere (case-insensitive) in the command
# itself, the kube context, the gcloud project, or the Terraform workspace or
# directory. This is deliberately broad: a false positive (e.g. "product") only
# means running the command yourself.
#
# Fails closed: any error exits 2, which blocks the tool call. A plain exit 1
# would let the command run.
#
# Install: ~/.claude/hooks/kube-context-guard.sh (chmod +x), needs jq.
set -Eeuo pipefail
trap '(( BASH_SUBSHELL == 0 )) && echo "kube-context-guard.sh failed at line $LINENO; blocking to be safe." >&2; exit 2' ERR

PROD_RE='prod|prd'

if ! command -v jq > /dev/null; then
  echo "kube-context-guard.sh needs jq; blocking to be safe." >&2
  exit 2
fi

input="$(cat)"
cmd="$(jq -r '.tool_input.command // empty' <<<"$input")"
# Join backslash continuations, then treat remaining newlines as the command
# separators they are, so heredoc text isn't read as one long command.
cmd="${cmd//$'\\\n'/ }"
cmd="${cmd//$'\n'/;}"
cwd="$(jq -r '.cwd // empty' <<<"$input")"
[[ -z "$cmd" ]] && exit 0

# True if one of the tools ($1) is invoked with one of the verbs ($2) within the
# same shell segment, e.g. "kubectl --context x apply". Verbs must be whole
# words, so flags like helm's --set don't count.
invokes() {
  grep -Eq "(^|[^[:alnum:]_-])($1)([[:space:]][^;&|]*)?[[:space:]]($2)([[:space:]]|$)" <<<"$cmd"
}

# Prints the value of the first --flag=value or --flag value in the command.
flag_value() {
  grep -Eo -- "--($1)[= ][^ ]+" <<<"$cmd" | head -n1 | sed -E "s/^--($1)[= ]//" || true
}

kube_verbs='apply|create|replace|delete|patch|edit|scale|label|annotate|set|run|expose|autoscale|rollout[[:space:]]+(restart|undo|pause|resume)|cordon|uncordon|drain|taint|exec|cp|debug|use-context|set-context|delete-context|install|upgrade|uninstall|rollback|reconcile|suspend|resume|bootstrap|move|init|sync|terminate-op'
gcloud_verbs='create|delete|update|patch|set|add-iam-policy-binding|remove-iam-policy-binding|set-iam-policy|deploy|resize|start|stop|reset|enable|disable|import|rollback|upgrade|attach|detach|move|apply|replace|rm|cp|mv|rsync'
terraform_verbs='apply|destroy|import|taint|untaint|force-unlock|state[[:space:]]+(mv|rm|push|replace-provider)|workspace[[:space:]]+(select|new|delete)'

targets=()

if invokes 'kubectl|helm|flux|clusterctl|argocd' "$kube_verbs"; then
  context="$(flag_value '(kube-)?context')"
  if [[ -z "$context" ]]; then
    kubeconfig="$(grep -Eo 'KUBECONFIG=[^ ]+' <<<"$cmd" | head -n1 | cut -d= -f2- || true)"
    context="$(KUBECONFIG="${kubeconfig:-${KUBECONFIG:-}}" kubectl config current-context 2>/dev/null || echo unknown)"
  fi
  targets+=("kube context: $context")
fi

if invokes 'gcloud|gsutil' "$gcloud_verbs"; then
  project="$(flag_value 'project')"
  if [[ -z "$project" ]]; then
    project="$(gcloud config get-value project 2>/dev/null || echo unknown)"
  fi
  targets+=("gcloud project: ${project:-unknown}")
fi

if invokes 'terraform|tofu|terragrunt' "$terraform_verbs"; then
  directory="$(grep -Eo -- '-chdir=[^ ]+' <<<"$cmd" | head -n1 | cut -d= -f2- || true)"
  if [[ -z "$directory" ]]; then
    directory="$cwd"
  elif [[ "$directory" != /* ]]; then
    directory="$cwd/$directory"
  fi
  workspace="$(grep -Eo 'TF_WORKSPACE=[^ ]+' <<<"$cmd" | head -n1 | cut -d= -f2- || true)"
  if [[ -z "$workspace" ]]; then
    workspace="${TF_WORKSPACE:-$(cat "$directory/.terraform/environment" 2>/dev/null || echo default)}"
  fi
  targets+=("terraform directory: $directory" "terraform workspace: $workspace")
fi

[[ ${#targets[@]} -eq 0 ]] && exit 0

summary="$(printf '%s; ' "${targets[@]}")"
summary="${summary%; }"

if grep -Eiq "$PROD_RE" <<<"$cmd" || printf '%s\n' "${targets[@]}" | grep -Eiq "$PROD_RE"; then
  decision="deny"
  reason="Blocked: mutating command that looks like PRODUCTION ($summary). Give the user the exact command to run themselves."
else
  decision="ask"
  reason="Mutating command ($summary)."
fi

jq -n --arg d "$decision" --arg r "$reason" '{
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    permissionDecision: $d,
    permissionDecisionReason: $r
  }
}'

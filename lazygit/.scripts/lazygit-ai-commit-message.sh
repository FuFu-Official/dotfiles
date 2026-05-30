#!/usr/bin/env bash

set -euo pipefail

if git diff --staged --quiet; then
  printf '%s\n' 'No staged changes to commit.' >&2
  exit 1
fi

workspace="/tmp/opencode-commit-msg"
mkdir -p "$workspace"

if ! command -v opencode >/dev/null 2>&1; then
  printf '%s\n' 'opencode command not found.' >&2
  exit 1
fi

if ! command -v flock >/dev/null 2>&1; then
  printf '%s\n' 'flock command not found.' >&2
  exit 1
fi

server_url="${OPENCODE_GIT_COMMIT_SERVER_URL:-http://127.0.0.1:14096}"
server_url="${server_url%/}"

if [[ "$server_url" =~ ^http://([^:/]+):([0-9]+)$ ]]; then
  server_host="${BASH_REMATCH[1]}"
  server_port="${BASH_REMATCH[2]}"
else
  printf 'Unsupported OPENCODE_GIT_COMMIT_SERVER_URL: %s\n' "$server_url" >&2
  printf '%s\n' 'Expected format: http://host:port' >&2
  exit 1
fi

is_opencode_server_ready() {
  if { exec 3<>"/dev/tcp/$server_host/$server_port"; } 2>/dev/null; then
    exec 3>&-
    exec 3<&-
    return 0
  fi

  return 1
}

wait_for_opencode_server() {
  local attempts="${1:-30}"

  while [ "$attempts" -gt 0 ]; do
    if is_opencode_server_ready; then
      return 0
    fi
    attempts=$((attempts - 1))
    [ "$attempts" -gt 0 ] && sleep 1
  done

  return 1
}

ensure_opencode_server() {
  local lock_file="$workspace/server.lock"
  local log_file="$workspace/server.log"

  if is_opencode_server_ready; then
    return 0
  fi

  if (
    flock -x -w 30 9
    if is_opencode_server_ready; then
      exit 0
    fi

    if ! wait_for_opencode_server 2; then
      nohup opencode serve --hostname "$server_host" --port "$server_port" \
        9>&- >"$log_file" 2>&1 &
    fi

    wait_for_opencode_server 30
  ) 9>"$lock_file"; then
    return 0
  fi

  printf 'Failed to start opencode server at %s\n' "$server_url" >&2
  printf 'See log: %s\n' "$log_file" >&2
  return 1
}

selected_model="${OPENCODE_COMMIT_MODEL:-}"

if [ -z "$selected_model" ]; then
  available_models="$(opencode models)"
  preferred_models=(
    "github-copilot/gpt-5.2-codex"
    "github-copilot/gpt-5.2"
    "tabcode/gpt-5.4"
    "tabcode/gpt-5.2"
  )

  for candidate in "${preferred_models[@]}"; do
    if printf '%s\n' "$available_models" | grep -Fxq "$candidate"; then
      selected_model="$candidate"
      break
    fi
  done

  if [ -z "$selected_model" ]; then
    while IFS= read -r candidate; do
      selected_model="$candidate"
      break
    done <<EOF
$available_models
EOF
  fi
fi

if [ -z "$selected_model" ]; then
  printf '%s\n' 'No available opencode models found.' >&2
  exit 1
fi

history_file="$(mktemp "$workspace/history.XXXXXX.txt")"
diff_file="$(mktemp "$workspace/diff.XXXXXX.txt")"
msg_file="$(mktemp /tmp/commit_msg.XXXXXX)"
trap 'rm -f "$history_file" "$diff_file" "$msg_file"' EXIT

git log --format='%s' -12 > "$history_file"
git diff --staged > "$diff_file"

prompt=$(cat <<'EOF'
You are an expert at writing Git commit messages.

Your task is to:
1. Analyze the staged code changes.
2. Identify the main affected area or scope.
3. Determine the most appropriate commit type.
4. Decide whether the change is breaking.
5. Infer the repository's preferred commit style from recent commit history.
6. Write one clear, concise commit message that matches that style.

Instructions:
1. Use the attached recent commit subjects to infer whether this repository prefers Chinese or English.
2. Use the attached recent commit subjects to infer whether this repository prefers conventional commits, scope prefixes like "area: subject", or plain subjects.
3. Follow the dominant recent style instead of forcing conventional commits.
4. If the history strongly suggests conventional commits, use this structure: <type>(<scope>): <description>.
5. Allowed conventional types when that style is appropriate: feat, fix, docs, style, refactor, perf, test, chore, build, ci, revert.
6. Add a scope in parentheses when a specific area is clearly affected.
7. If the change is breaking and the inferred style is conventional commits, add `!` immediately after the type or scope.
8. If the history is mixed or too weak to infer, prefer a concise English subject in the style "area: subject" when a clear area exists, otherwise a plain concise subject.
9. Keep the first line concise, ideally under 72 characters.
10. Write in present tense and do not end the subject line with a period.
11. If the staged change is large or spans multiple concerns, include a commit body.
12. When including a body for multi-part changes, add a blank line after the subject and then list the key changes as short bullet points, one concern per line.
13. If the staged change is small and focused, omit the body unless the repository history strongly suggests bodies are common.
14. Do not mention that you inferred from history.
15. Output ONLY the raw commit message text. No markdown, no code fences, no backticks, no explanations.

Examples when conventional commit style is appropriate:
- build!: update Webpack configuration to support ES modules
- feat(products): add advanced search filter to products view
- fix: prevent saving users without a secondary email
- chore: clean unused dependencies in package.json
- ci: adjust GitHub Actions workflow to run tests on Node 20
- docs: update installation guide with new system requirements
- perf: optimize SQL query to reduce dashboard load time
- refactor: reorganize components to improve code readability
- revert: revert 'feat: add OTP authentication'
- style: apply standard formatting according to prettier
- test: add unit tests for form validation module
EOF
)

ensure_opencode_server

opencode run \
  --attach "$server_url" \
  --dir "$workspace" \
  --title lazygit-commit-message \
  --model "$selected_model" \
  -f "$history_file" \
  -f "$diff_file" \
  -- "$prompt" > "$msg_file"

git commit -s -e -F "$msg_file"

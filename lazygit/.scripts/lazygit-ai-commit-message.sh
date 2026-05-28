#!/usr/bin/env bash

set -euo pipefail

if git diff --staged --quiet; then
  printf '%s\n' 'No staged changes to commit.' >&2
  exit 1
fi

workspace="/tmp/opencode-commit-msg"
mkdir -p "$workspace"

selected_model="${OPENCODE_COMMIT_MODEL:-}"

if [ -z "$selected_model" ]; then
  available_models="$(opencode models github-copilot)"
  preferred_models=(
    "tabcode/gpt-5.4"
    "tabcode/gpt-5.2"
    "github-copilot/gpt-5-mini"
    "github-copilot/gpt-5.2-codex"
    "github-copilot/gpt-5.4-mini"
    "github-copilot/gpt-5.2"
    "github-copilot/gpt-4.1"
  )

  for candidate in "${preferred_models[@]}"; do
    if printf '%s\n' "$available_models" | grep -Fxq "$candidate"; then
      selected_model="$candidate"
      break
    fi
  done

  if [ -z "$selected_model" ]; then
    selected_model="$(printf '%s\n' "$available_models" | head -n 1)"
  fi
fi

if [ -z "$selected_model" ]; then
  printf '%s\n' 'No github-copilot models available in opencode.' >&2
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

opencode run \
  --dir "$workspace" \
  --title lazygit-commit-message \
  --model "$selected_model" \
  -f "$history_file" \
  -f "$diff_file" \
  -- "$prompt" > "$msg_file"

git commit -e -F "$msg_file"

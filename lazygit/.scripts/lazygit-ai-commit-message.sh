#!/usr/bin/env bash

set -euo pipefail

if git diff --staged --quiet; then
  printf '%s\n' 'No staged changes to commit.' >&2
  exit 1
fi

workspace="/tmp/opencode-commit-msg"
mkdir -p "$workspace"

history_file="$(mktemp "$workspace/history.XXXXXX.txt")"
diff_file="$(mktemp "$workspace/diff.XXXXXX.txt")"
msg_file="$(mktemp /tmp/commit_msg.XXXXXX)"
trap 'rm -f "$history_file" "$diff_file" "$msg_file"' EXIT

git log --format='%s' -12 > "$history_file"
git diff --staged > "$diff_file"

prompt=$(cat <<'EOF'
Generate a git commit message for the attached staged diff.

Use the attached recent commit subjects to infer this repository's preferred style.

Rules:
- Infer whether the repository prefers Chinese or English from the history examples.
- Infer whether the repository prefers conventional commits, scope prefixes like "area: subject", or plain subjects.
- Follow the dominant recent style instead of forcing conventional commits.
- If the history is mixed or too weak to infer, prefer a concise English subject in the style "area: subject" when a clear area exists, otherwise a plain concise subject.
- Keep the first line concise, ideally under 72 characters.
- Add a body only if the staged change is substantial and the repository history suggests bodies are common.
- Do not mention that you inferred from history.
- Output ONLY the raw commit message text. No markdown, no code fences, no explanations.
EOF
)

opencode run \
  --dir "$workspace" \
  --title lazygit-commit-message \
  --model github-copilot/gpt-5.4-mini \
  -f "$history_file" \
  -f "$diff_file" \
  -- "$prompt" > "$msg_file"

git commit -e -F "$msg_file"

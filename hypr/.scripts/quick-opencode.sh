#!/usr/bin/env bash

set -euo pipefail

if ! command -v opencode >/dev/null 2>&1; then
  printf '%s\n' 'opencode command not found.' >&2
  exit 1
fi

if [ -z "${TABCODE_API_KEY:-}" ] && command -v fish >/dev/null 2>&1; then
  tabcode_api_key="$(fish -c 'printf %s "$TABCODE_API_KEY"')"
  if [ -n "$tabcode_api_key" ]; then
    export TABCODE_API_KEY="$tabcode_api_key"
  fi
fi

workspace="/tmp/quick-opencode"
mkdir -p "$workspace"
cd "$workspace"
exec opencode --continue .

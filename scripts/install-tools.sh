#!/usr/bin/env bash
set -e

mkdir -p "$HOME/.local/bin"

if ! command -v k9s >/dev/null 2>&1; then
  curl -sS https://webi.sh/k9s | sh || true
fi

if ! command -v ansible >/dev/null 2>&1; then
  pipx install --include-deps ansible || true
fi

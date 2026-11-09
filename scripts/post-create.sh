#!/usr/bin/env bash
set -euo pipefail

# Install managed Bash configuration before running installers.
mkdir -p "$HOME/.config"

BASHRC="$HOME/.bashrc"
START_MARKER="# >>> Ninjatronics DevOps IDE >>>"
END_MARKER="# <<< Ninjatronics DevOps IDE <<<"

touch "$BASHRC"

# Remove the previous managed block, if present.
if grep -Fq "$START_MARKER" "$BASHRC"; then
  sed -i "/^${START_MARKER}$/,/^${END_MARKER}$/d" "$BASHRC"
fi

# Add the current configuration.
{
  printf '\n%s\n' "$START_MARKER"
  cat config/shell/bashrc
  printf '\n%s\n' "$END_MARKER"
} >>"$BASHRC"

bash scripts/install-lazyvim.sh
bash scripts/install-nvim-clipboard.sh
bash scripts/install-tools.sh
bash scripts/install-copilot.sh

cp config/tmux/tmux.conf "$HOME/.tmux.conf" || true

# Synchronize LazyVim plugins.
nvim --headless "+Lazy! sync" +qa

# Install and verify required Mason packages.
nvim --headless "+luafile scripts/install-mason.lua" +qa

echo "DevOps LazyVim IDE is ready."

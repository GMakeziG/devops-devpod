#!/usr/bin/env bash
set -euo pipefail

bash scripts/install-lazyvim.sh
bash scripts/install-nvim-clipboard.sh
bash scripts/install-tools.sh

mkdir -p "$HOME/.config"

cp config/tmux/tmux.conf "$HOME/.tmux.conf" || true

if ! grep -q "Ninjatronics DevOps IDE" "$HOME/.bashrc"; then
  cat config/shell/bashrc >>"$HOME/.bashrc"
fi

nvim --headless "+Lazy! sync" +qa || true

echo "DevOps LazyVim IDE is ready."

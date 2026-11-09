#!/usr/bin/env bash
set -euo pipefail

NVIM_DIR="$HOME/.config/nvim"
PLUGIN_DIR="$NVIM_DIR/lua/plugins"
SOURCE_DIR="config/nvim/lua/plugins"

if [ ! -f "$NVIM_DIR/init.lua" ]; then
  if [ -d "$NVIM_DIR" ] && [ -n "$(ls -A "$NVIM_DIR")" ]; then
    echo "ERROR: Existing Neovim configuration found."
    exit 1
  fi

  git clone https://github.com/LazyVim/starter "$NVIM_DIR"
  rm -rf "$NVIM_DIR/.git"
fi

mkdir -p "$PLUGIN_DIR"

# Deploy repository-managed plugin configurations.
for file in "$SOURCE_DIR"/*.lua; do
  [ -f "$file" ] || continue
  cp "$file" "$PLUGIN_DIR/$(basename "$file")"
done

echo "LazyVim configuration installed."

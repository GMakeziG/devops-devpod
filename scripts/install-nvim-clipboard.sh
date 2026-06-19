#!/usr/bin/env bash
set -euo pipefail

NVIM_CONFIG="$HOME/.config/nvim"
CLIPBOARD_FILE="$NVIM_CONFIG/lua/config/options.lua"

mkdir -p "$NVIM_CONFIG/lua/config"

cat >"$CLIPBOARD_FILE" <<'EOF'
-- Use system clipboard by default
vim.opt.clipboard = "unnamedplus"

-- OSC52 clipboard support for SSH, DevPod, headless servers, and browser terminals
vim.g.clipboard = {
  name = "OSC52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
    ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
  },
}
EOF
